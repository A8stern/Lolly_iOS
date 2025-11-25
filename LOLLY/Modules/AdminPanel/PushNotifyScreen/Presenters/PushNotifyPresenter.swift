//
//  PushNotifyPresenter.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

internal import UIKit

protocol PushNotifyPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// События показа экрана
    func onViewWillAppear()

    /// Триггер загрузки данных
    func onViewDidAppear()

    /// Закрыть экран
    func closePush()

    /// Получить роль пользователя
    func getUserRole(phone: String) -> UserRoleStatus
}

final class PushNotifyViewPresenter {
    // MARK: - Private Properties

    private unowned let view: PushNotifyView
    private let coordinator: AdminCoordinator
    private let authorizationService: AuthorizationServiceInterface

    // MARK: - Initialization

    init(
        view: PushNotifyView,
        coordinator: AdminCoordinator,
        authorizationService: AuthorizationServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.authorizationService = authorizationService
    }
}

extension PushNotifyViewPresenter: PushNotifyPresenter {
    func onViewDidLoad() {
        let response = PushNotifyModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func closePush() {
        coordinator.closePush()
    }

    func getUserRole(phone: String) -> UserRoleStatus {
        let isMock = true
        if isMock {
            return .admin
        }

        var role = nil as UserRoleStatus?
        Task {
            do {
                let status: UserRoleStatus = try await authorizationService.fetchUserStatus(phone: phone)
                role = status
            } catch {
                // TODO: - Обработчик ошибок
                print("PushNotifyPresenter userRole error")
            }
        }
        guard let role else { return UserRoleStatus.unknown }
        return role
    }
}

// MARK: - Private Methods

extension PushNotifyViewPresenter {
    fileprivate func responseInitialData(response _: PushNotifyModels.InitialData.Response) {
        let viewModel = PushNotifyModels.InitialData.ViewModel(
            title: L10n.AdminPanel.PushNotify.title,
            pushNotifyViewModel: makePushNotifyViewModel()
        )

        view.displayInitialData(viewModel: viewModel)
    }

    fileprivate func makePushNotifyViewModel() -> PushNotifySectionViewModel? {
        PushNotifySectionViewModel(
            titleInputViewModel: TextFieldInputViewModel(
                title: L10n.AdminPanel.PushNotify.inputTitle,
                placeholder: L10n.AdminPanel.PushNotify.inputTitle,
                keyboardType: .default,
                maxLength: 50
            ),
            textInputViewModel: TextFieldInputViewModel(
                title: L10n.AdminPanel.PushNotify.inputText,
                placeholder: L10n.AdminPanel.PushNotify.inputText,
                keyboardType: .default,
                maxLength: 150
            ),
            confirmButtonViewModel: ButtonViewModel(
                title: L10n.AdminPanel.PushNotify.confirmationButton,
                type: .custom(
                    ButtonViewModel.Config(
                        icon: nil,
                        imageTintColor: Colors.Constants.black,
                        contentColor: Colors.Constants.black,
                        enabledColor: Colors.Constants.yellow,
                        pressedColor: Colors.Constants.yellow,
                        disabledColor: Colors.Controls.disabled,
                        needImageTint: false
                    )
                ),
                size: .medium,
                tapHandler: nil // TODO: - Логика отправки push
            )
        )
    }
}
