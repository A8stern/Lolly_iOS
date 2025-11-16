//
//  ScannerPresenter.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

import UIKit

protocol ScannerPresenter: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()
    func onCloseTap()
}

final class ScannerViewPresenter {
    private weak var view: ScannerView?
    private weak var coordinator: GeneralCoordinator?
    private let stickersService: StickersServiceInterface
    private let screenBrightnessManager: ScreenBrightnessManagerInterface

    private var initialDataTask: Task<Void, Never>?
    private var checkChangesTask: Task<Void, Never>?

    private var changesStatus: ChangingCheckStatus = .error
    private var hasStartedChecking = false

    init(
        view: ScannerView,
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
        initialDataTask?.cancel()
        checkChangesTask?.cancel()
    }
}

extension ScannerViewPresenter: ScannerPresenter {
    func onViewDidLoad() { }

    func onViewWillAppear() {
        screenBrightnessManager.set(to: .full)
        let response = ScannerModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewDidAppear() { }

    func onViewWillDisappear() {
        screenBrightnessManager.restore()
        initialDataTask?.cancel()
        initialDataTask = nil

        checkChangesTask?.cancel()
        checkChangesTask = nil
        hasStartedChecking = false
    }

    func onCloseTap() {
        initialDataTask?.cancel()
        initialDataTask = nil

        checkChangesTask?.cancel()
        checkChangesTask = nil
        hasStartedChecking = false

        Task { @MainActor [weak self] in
            guard let coordinator = self?.coordinator else { return }
            coordinator.closeScanner()
        }
    }
}

extension ScannerViewPresenter {
    fileprivate func responseInitialData(response _: ScannerModels.InitialData.Response) {
        initialDataTask?.cancel()
        initialDataTask = Task { [weak self] in
            guard let self else { return }
            do {
                let hash = try await fetchHash()

                let viewModel = ScannerModels.InitialData.ViewModel(
                    QRSectionViewModel: makeQRSectionViewModel(hash: hash)
                )
                checkChanges()
                await MainActor.run { [weak self] in
                    guard let self, let view else { return }
                    view.displayInitialData(viewModel: viewModel)
                }
            } catch is CancellationError {
                return
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }

    fileprivate func makeQRSectionViewModel(hash: String) -> QRSectionViewModel {
        return QRSectionViewModel(
            qrImage: generateQRCode(from: hash),
            text: L10n.Scanner.title
        )
    }

    fileprivate func fetchHash() async throws -> String {
        let hash = try await stickersService.generateHash()
        return hash
    }

    fileprivate func generateQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }

        let transform = CGAffineTransform(
            scaleX: Constants.qrSize / outputImage.extent.size.width,
            y: Constants.qrSize / outputImage.extent.size.height
        )
        let scaledImage = outputImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    fileprivate func checkChanges() {
        guard hasStartedChecking == false else { return }
        hasStartedChecking = true

        checkChangesTask?.cancel()
        checkChangesTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled, changesStatus == .error {
                let status = await stickersService.changingCheck()
                if Task.isCancelled {
                    return
                }
                changesStatus = status

                if status != .error {
                    await MainActor.run { [weak self] in
                        guard let self, let coordinator else { return }
                        coordinator.showLoading()
                    }
                    return
                } else {
                    do {
                        try await Task.sleep(nanoseconds: 5000000000)
                    } catch {
                        return
                    }
                }
            }
        }
    }
}

// MARK: - Constants

extension ScannerViewPresenter {
    fileprivate enum Constants {
        static let qrSize: CGFloat = 325.0
    }
}
