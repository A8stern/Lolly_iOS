//
//  ScannerPresenter.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

import UIKit

internal protocol ScannerPresenter: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()
    func onCloseTap()
}

final class ScannerViewPresenter {
    private unowned let view: ScannerView
    private let coordinator: GeneralCoordinator
    private let screenBrightnessManager: ScreenBrightnessManagerInterface

    init(
        view: ScannerView,
        coordinator: GeneralCoordinator,
        screenBrightnessManager: ScreenBrightnessManagerInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.screenBrightnessManager = screenBrightnessManager
    }
}

extension ScannerViewPresenter: ScannerPresenter {
    func onViewDidLoad() {
        let response = ScannerModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewWillAppear() {
        screenBrightnessManager.set(to: .full)
    }

    func onViewDidAppear() { }

    func onViewWillDisappear() {
        screenBrightnessManager.restore()
    }

    func onCloseTap() {
        coordinator.closeScanner()
    }
}

private extension ScannerViewPresenter {
    func responseInitialData(response: ScannerModels.InitialData.Response) {
        let viewModel = ScannerModels.InitialData.ViewModel(
            QRSectionViewModel: makeQRSectionViewModel(),
        )

        view.displayInitialData(viewModel: viewModel)
    }

    func makeQRSectionViewModel() -> QRSectionViewModel {
        let fakeMockInternalUserId = "12345"
        return QRSectionViewModel(
            qrImage: generateQRCode(from: fakeMockInternalUserId),
            text: L10n.Scanner.title
        )
    }

    func generateQRCode(from string: String) -> UIImage? {
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
}

// MARK: - Constants

private extension ScannerViewPresenter {
    enum Constants {
        static let qrSize: CGFloat = 325.0
    }
}
