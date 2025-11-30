//
//  QRcodePresenter.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

import UIKit

protocol QRcodePresenter: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()
    func onCloseTap()
}

final class QRcodeViewPresenter {
    private weak var view: QRcodeView?
    private weak var coordinator: GeneralCoordinator?
    private let stickersService: StickersServiceInterface
    private let screenBrightnessManager: ScreenBrightnessManagerInterface

    private var checkChangesTask: Task<Void, Never>?

    private var changesStatus: ChangingCheckStatus = .notChanged
    private var isCheckingChanges = false

    init(
        view: QRcodeView,
        coordinator: GeneralCoordinator,
        stickersService: StickersServiceInterface,
        screenBrightnessManager: ScreenBrightnessManagerInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.stickersService = stickersService
        self.screenBrightnessManager = screenBrightnessManager
    }

    deinit {
        checkChangesTask?.cancel()
    }
}

extension QRcodeViewPresenter: @MainActor QRcodePresenter {
    func onViewDidLoad() {
        responseInitialData()
        makeQrCode()
    }

    func onViewWillAppear() {
        screenBrightnessManager.set(to: .full)
    }

    func onViewDidAppear() { }

    func onViewWillDisappear() {
        screenBrightnessManager.restore()
    }

    @MainActor
    func onCloseTap() {
        stopCheckChangesTask()

        coordinator?.closeQRcode()
    }
}

extension QRcodeViewPresenter {
    private func stopCheckChangesTask() {
        checkChangesTask?.cancel()
        checkChangesTask = nil
        isCheckingChanges = false
    }

    private func responseInitialData() {
        let viewModel = QRcodeModels.InitialData.ViewModel(
            qrViewModel: QRViewModel(isSkeletonable: true),
            caption: L10n.QRcode.Caption.loading
        )
        view?.displayInitialData(viewModel: viewModel)
    }

    private func makeQrCode() {
        Task {
            do {
                let hash = try await stickersService.generateHash()

                await MainActor.run { [weak self] in
                    guard let self else { return }
                    let viewModel = QRcodeModels.QRcode.ViewModel(
                        qrViewModel: makeQRViewModel(hash: hash),
                        caption: L10n.QRcode.Caption.success
                    )
                    view?.displayQRcode(viewModel: viewModel)
                }

                checkChanges()
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    view?.showSnack(with: .error(text: error.readableDescription))
                }
            }
        }
    }

    fileprivate func makeQRViewModel(hash: String) -> QRViewModel {
        return QRViewModel(
            qrImage: generateQRCode(from: hash)
        )
    }

    fileprivate func generateQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        // Уровень коррекции ошибок: L, M, Q, H (H = наибольшая устойчивость)
        filter.setValue("H", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }

        let width = outputImage.extent.width
        let height = outputImage.extent.height

        guard width > 0 && height > 0 else { return nil }

        let transform = CGAffineTransform(
            scaleX: Constants.qrSize / width,
            y: Constants.qrSize / height
        )
        let scaledImage = outputImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    fileprivate func checkChanges() {
        guard isCheckingChanges == false else { return }
        isCheckingChanges = true

        checkChangesTask?.cancel()
        checkChangesTask = Task { [weak self] in
            defer {
                self?.resetCheckingFlag()
            }
            guard let self = self else { return }
            await pollStatus()
        }
    }

    private func resetCheckingFlag() {
        Task { @MainActor [weak self] in
            self?.isCheckingChanges = false
        }
    }

    private func pollStatus() async {
        while self.changesStatus == .notChanged && isCheckingChanges {
            do {
                let status = try await self.stickersService.changingCheck()
                await handle(status: status)
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    view?.showSnack(with: .error(text: error.readableDescription))
                    stopCheckChangesTask()
                }
                break
            }
        }
    }

    private func handle(status: ChangingCheckStatus) async {
        self.changesStatus = status
        switch status {
            case .deducted, .credited:
                await showLoading()

            case .notChanged:
                await sleepFiveSeconds()

            case .error:
                await closeQRcode()
        }
    }

    private func showLoading() async {
        await MainActor.run { [weak self] in
            guard let self = self, let coordinator = self.coordinator else { return }
            coordinator.showLoading(status: changesStatus)
        }
    }

    private func sleepFiveSeconds() async {
        do {
            try await Task.sleep(nanoseconds: 5_000_000_000)
        } catch { return }
    }

    private func closeQRcode() async {
        await MainActor.run { [weak self] in
            self?.onCloseTap()
        }
    }
}

// MARK: - Constants

extension QRcodeViewPresenter {
    fileprivate enum Constants {
        static let qrSize: CGFloat = 512
    }
}
