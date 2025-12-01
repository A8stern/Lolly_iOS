//
//  QRScanPresenter.swift
//  Brewsell
//
//  Created by Kovalev Gleb on 29.11.2025.
//

import Foundation
import UIKit

protocol QRScanPresenter: AnyObject {
    func onViewDidLoad()
    func onCloseTap()
    func onQRCodeScanned(_ code: String)
    func openCameraPermissionScreen()
}

final class QRScanViewPresenter {
    private unowned let view: QRScanView
    private let coordinator: AdminCoordinator
    private let stickersService: StickersServiceInterface

    init(
        view: QRScanView,
        coordinator: AdminCoordinator,
        service: StickersServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.stickersService = service
    }
}

extension QRScanViewPresenter: QRScanPresenter {
    func onViewDidLoad() {}

    func onCloseTap() {
        coordinator.closePush()
    }

    func onQRCodeScanned(_ code: String) {
        Task {
            do {
                if try await stickersService.baristaScan(hash: code) {
                    showLoadingScreen()
                } else {
                    showErrorAlert(text: L10n.Qr.Error.response)
                }
            } catch {
                showErrorAlert(text: L10n.Qr.Error.internal)
            }
        }
    }

    func openCameraPermissionScreen() {
        coordinator.showPhotoPermission()
    }
}

private extension QRScanViewPresenter {
    func showErrorAlert(text: String) {
        view.showSnack(with: .error(icon: nil, text: text))
    }

    func showLoadingScreen() {
        coordinator.showAdminLoading()
    }
}
