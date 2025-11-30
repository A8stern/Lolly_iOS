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
    private let input: LoyaltyLoadingInput
    private let coordinator: GeneralCoordinator
    private let stickersService: StickersServiceInterface
    private var changesStatus: ChangingCheckStatus = .notChanged

    init(
        view: LoyaltyLoadingView,
        input: LoyaltyLoadingInput,
        coordinator: GeneralCoordinator,
        service: StickersServiceInterface
    ) {
        self.view = view
        self.input = input
        self.coordinator = coordinator
        self.stickersService = service
    }
}

extension LoyaltyLoadingViewPresenter: @MainActor LoyaltyLoadingPresenter {
    func onViewDidLoad() {
        checkChanges()
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func onViewWillDisappear() { }

    @MainActor
    func onCloseTap() {
        Task { @MainActor in
            coordinator.closeLoading()
        }
    }
}

extension LoyaltyLoadingViewPresenter {
    fileprivate func checkChanges() {
        Task { @MainActor [weak self] in
            guard let self = self else { return }

            do {
                try await Task.sleep(nanoseconds: 5_000_000_000)

                switch self.input.status {
                    case .deducted, .credited:
                        self.view.changeBackgroundColor(to: Colors.Status.success.color)
                        self.view.showText(text: L10n.Loyalty.Loading.success)

                    case .notChanged, .error:
                        self.view.changeBackgroundColor(to: Colors.Status.error.color)
                        self.view.showText(text: L10n.Loyalty.Loading.error)
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.onCloseTap()
                }
            }
        }
    }
}
