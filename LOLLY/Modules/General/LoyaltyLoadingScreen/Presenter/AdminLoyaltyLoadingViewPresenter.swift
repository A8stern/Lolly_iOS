//
//  AdminLoyaltyLoadingViewPresenter.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 29.11.2025.
//

import UIKit

final class AdminLoyaltyLoadingViewPresenter {
    private unowned let view: LoyaltyLoadingView
    private let coordinator: AdminCoordinator

    init(
        view: LoyaltyLoadingView,
        coordinator: AdminCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

extension AdminLoyaltyLoadingViewPresenter: LoyaltyLoadingPresenter {
    func onViewDidLoad() {
        baristaScan()
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func onViewWillDisappear() { }

    func onCloseTap() {
        Task { @MainActor in
            coordinator.closePush()
        }
    }
}

extension AdminLoyaltyLoadingViewPresenter {
    fileprivate func baristaScan() {
        view.changeBackgroundColor(to: Colors.Status.success.color)
        view.showText(text: L10n.Loyalty.Loading.success)
    }
}

// MARK: - Constants

extension LoyaltyLoadingViewPresenter {
    fileprivate enum Constants {
        static let qrSize: CGFloat = 325.0
    }
}
