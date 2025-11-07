//
//  AuthMethodsPresenter.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

internal import UIKit

protocol AuthMethodsPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// События показа экрана
    func onViewWillAppear()

    /// Триггер загрузки данных
    func onViewDidAppear()
}

final class AuthMethodsViewPresenter {
    // MARK: - Private Properties

    private unowned let view: AuthMethodsView
    private let coordinator: AuthCoordinator

    // MARK: - Initialization

    init(
        view: AuthMethodsView,
        coordinator: AuthCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - AuthMethodsPresenter

extension AuthMethodsViewPresenter: AuthMethodsPresenter {
    func onViewDidLoad() {
        // TODO: Добавить бизнес логику доступны ли нам авторизации
        let response = AuthMethodsModels.InitialData.Response(
            isPhoneAuthAvailable: true,
            isAppleAuthAvailable: false
        )
        responseInitialData(response: response)
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }
}

// MARK: - Private Methods

extension AuthMethodsViewPresenter {
    fileprivate func responseInitialData(response: AuthMethodsModels.InitialData.Response) {
        let phoneSignInButtonViewModel: ButtonViewModel? = {
            guard response.isPhoneAuthAvailable else { return nil }
            return makePhoneSignInButtonViewModel()
        }()
        let appleSignInButtonViewModel: ButtonViewModel? = {
            guard response.isAppleAuthAvailable else { return nil }
            return makeAppleSignInButtonViewModel()
        }()

        view.displayInitialData(
            viewModel: AuthMethodsModels.InitialData.ViewModel(
                backgroundVideoViewModel: makeVideoViewModel(),
                phoneSignInButtonViewModel: phoneSignInButtonViewModel,
                appleSignInButtonViewModel: appleSignInButtonViewModel,
                conditions: L10n.AuthMethods.conditions
            )
        )
    }

    private func makeVideoViewModel() -> VideoViewModel {
        VideoViewModel(fileName: "promo")
    }

    private func makePhoneSignInButtonViewModel() -> ButtonViewModel {
        ButtonViewModel(
            title: L10n.AuthMethods.Buttons.signInWithPhone,
            type: .secondary(.none),
            style: .liquidGlassIfPossible,
            size: .large,
            tapHandler: { [weak self] in
                guard let self else { return }
                coordinator.openPhoneLogIn()
            }
        )
    }

    private func makeAppleSignInButtonViewModel() -> ButtonViewModel {
        ButtonViewModel(
            title: L10n.AuthMethods.Buttons.signInWithApple,
            type: .custom(.appleSignIn()),
            size: .large,
            tapHandler: { [weak self] in
                guard let self else { return }
                requestSignInWithApple()
            }
        )
    }

    private func requestSignInWithApple() {
//      TODO: Логика авторизации
    }
}

// MARK: - ButtonViewModel.Config

extension ButtonViewModel.Config {
    public static func appleSignIn() -> ButtonViewModel.Config {
        ButtonViewModel.Config(
            icon: .left(icon: Assets.Icons24.Social.apple),
            imageTintColor: Colors.Text.inverted,
            contentColor: Colors.Text.inverted,
            enabledColor: Colors.Custom.appleSignIn,
            pressedColor: Colors.Constants.grey,
            disabledColor: Colors.Constants.clear,
            needImageTint: true
        )
    }
}
