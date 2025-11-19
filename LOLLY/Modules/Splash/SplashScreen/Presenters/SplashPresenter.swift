//
//  SplashPresenter.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

import Foundation

protocol SplashPresenter: AnyObject {
    @MainActor
    func onViewDidLoad()
}

final class SplashViewPresenter {
    // MARK: - Private Properties

    private unowned let view: SplashView
    private let coordinator: SplashCoordinator
    private let sessionUseCase: SessionUseCaseInterface

    // TODO: Здесь должна быть проверка авторизован ли юзер
//    private let profileUseCase: Domain.ProfileUseCase

    // MARK: - Lifecycle

    init(
        view: SplashView,
        coordinator: SplashCoordinator,
        sessionUseCase: SessionUseCaseInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.sessionUseCase = sessionUseCase
    }
}

// MARK: - SplashPresenter

extension SplashViewPresenter: SplashPresenter {
    @MainActor
    func onViewDidLoad() {
        guard sessionUseCase.isAuthorized || sessionUseCase.credentialsExist else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                configureFlow()
            }
            return
        }

        Task { [weak self] in
            guard let self else { return }

            do {
                _ = try await sessionUseCase.refreshUserCredential()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    configureFlow()
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    configureFlow()
                }
            }
        }
    }
}

// MARK: - Private Methods

extension SplashViewPresenter {
    @MainActor
    fileprivate func configureFlow() {
        coordinator.close(animated: true)
    }
}

// MARK: - Constants

extension SplashViewPresenter {
    fileprivate enum Constants {
        static let defaultVerificationValue: Bool = false
    }
}
