//
//  LoyaltyLoadingPresenter.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 08.11.2025.
//

import UIKit

protocol LoyaltyLoadingPresenter: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()
    func onCloseTap()
}

final class LoyaltyLoadingViewPresenter {
    private unowned let view: LoyaltyLoadingView
    private let coordinator: GeneralCoordinator
    private let stickersService: StickersServiceInterface
    private var changesStatus: ChangingCheckStatus = .notChanged

    init(
        view: LoyaltyLoadingView,
        coordinator: GeneralCoordinator,
        service: StickersServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        stickersService = service
    }
}

extension LoyaltyLoadingViewPresenter: LoyaltyLoadingPresenter {
    func onViewDidLoad() {
        checkChanges()
    }

    func onViewWillAppear() {}

    func onViewDidAppear() {}

    func onViewWillDisappear() {}

    func onCloseTap() {
        Task { @MainActor in
            coordinator.closeLoading()
            changesStatus = .error
        }
    }
}

private extension LoyaltyLoadingViewPresenter {
    func checkChanges() {
        Task {
            while changesStatus == .notChanged {
                changesStatus = await stickersService.changingCheck()
                if changesStatus == .error {
                    await MainActor.run {
                        view.changeBackgroundColor(to: Colors.Status.error.color)
                        view.showText(text: L10n.Loyalty.Loading.error)
                    }
                } else if changesStatus == .credited || changesStatus == .deducted {
                    await MainActor.run {
                        view.changeBackgroundColor(to: Colors.Status.success.color)
                        view.showText(text: L10n.Loyalty.Loading.success)
                    }
                } else {
                    do {
                        try await Task.sleep(nanoseconds: 5_000_000_000)
                    } catch {
                        await MainActor.run {
                            changesStatus = .error
                            view.changeBackgroundColor(to: Colors.Status.error.color)
                            view.showText(text: L10n.Loyalty.Loading.error)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Constants

private extension LoyaltyLoadingViewPresenter {
    enum Constants {
        static let qrSize: CGFloat = 325.0
    }
}
