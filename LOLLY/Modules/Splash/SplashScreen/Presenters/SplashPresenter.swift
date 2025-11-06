//
//  SplashPresenter.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

import Foundation

protocol SplashPresenter: AnyObject {
    func onViewDidLoad()
}

final class SplashViewPresenter {
    // MARK: - Private Properties

    private unowned let view: SplashView
    private let coordinator: SplashCoordinator

// TODO: Здесь должна быть проверка авторизован ли юзер
//    private let profileUseCase: Domain.ProfileUseCase

    // MARK: - Lifecycle

    init(
        view: SplashView,
        coordinator: SplashCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - SplashPresenter

extension SplashViewPresenter: SplashPresenter {
    func onViewDidLoad() {
// MARK: Что-то в духе:
//        profileUseCase.fetchProfile { [weak self] result in
//            switch result {
//            case .success(let response):
//                let isVerified = response.emailVerified
//                self?.configureFlow(isEmailVerified: isVerified)
//
//            case .failure(let error):
//                switch error {
//                case .unknown:
//                    // приходит, если пользователь не авторизован,
//                    // значение должно апдейтнуться при логине/регистрации.
//                    self?.configureFlow()
//
//                default:
//                    // значит тут упала сеть
//                    self?.configureFlow()
//                }
//            }
//        }

//      Пока тут заглушка на 5 секунд
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            configureFlow()
        }
    }
}

// MARK: - Private Methods

private extension SplashViewPresenter {
    func configureFlow() {
        coordinator.close(animated: true)
    }
}

// MARK: - Constants

private extension SplashViewPresenter {
    enum Constants {
        static let defaultVerificationValue: Bool = false
    }
}
