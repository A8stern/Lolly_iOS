//
//  ProfileViewPresenter.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

private import PhoneNumberKit
internal import UIKit

protocol ProfilePresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    func onViewWillAppear()

    func onViewDidDisappear()

    func leave()

    func onLogoutTap()
}

final class ProfileViewPresenter {
    // MARK: - Private Properties

    private unowned let view: ProfileView
    private let coordinator: ProfileCoordinator
    private let profileService: ProfileServiceInterface

    // MARK: - Initialization

    init(
        view: ProfileView,
        coordinator: ProfileCoordinator,
        profileService: ProfileServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.profileService = profileService
    }
}

// MARK: - ProfilePresenter

extension ProfileViewPresenter: ProfilePresenter {
    func onViewDidLoad() {
        let response = ProfileModels.InitialData.Response()
        responseInitialData(response: response)
        loadProfileInfo()
    }

    func onViewWillAppear() { }

    func onViewDidDisappear() { }

    func leave() {
        coordinator.goBack(animated: true)
    }

    func onLogoutTap() {
        coordinator.logout()
    }
}

// MARK: - Private Methods

extension ProfileViewPresenter {
    fileprivate func responseInitialData(response _: ProfileModels.InitialData.Response) {
        let viewModel = ProfileModels.InitialData.ViewModel(title: "Профиль")
        view.displayInitialData(viewModel: viewModel)
    }

    fileprivate func loadProfileInfo() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let response = try await profileService.getProfileInfo()
                let profileResponse = ProfileModels.ProfileInfo.Response(
                    name: response.name,
                    phone: response.phone
                )
                responseProfileInfo(response: profileResponse)
            } catch {
                view.showSnack(with: .error(text: "Не удалось загрузить данные профиля"))
            }
        }
    }

    fileprivate func responseProfileInfo(response: ProfileModels.ProfileInfo.Response) {
        let viewModel = ProfileModels.ProfileInfo.ViewModel(
            name: response.name,
            phone: response.phone
        )
        view.displayProfileInfo(viewModel: viewModel)
    }
}
