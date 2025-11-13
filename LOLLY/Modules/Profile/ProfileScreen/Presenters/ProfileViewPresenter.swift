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
}

final class ProfileViewPresenter {
    // MARK: - Private Properties

    private unowned let view: ProfileView
    private let coordinator: ProfileCoordinator

    // MARK: - Initialization

    init(
        view: ProfileView,
        coordinator: ProfileCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - AuthMethodsPresenter

extension ProfileViewPresenter: ProfilePresenter {
    func onViewDidLoad() {
        let response = ProfileModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewWillAppear() { }

    func onViewDidDisappear() { }

    func leave() {
        coordinator.goBack(animated: true)
    }
}

// MARK: - Private Methods

extension ProfileViewPresenter {
    fileprivate func responseInitialData(response _: ProfileModels.InitialData.Response) {
        let viewModel = ProfileModels.InitialData.ViewModel(title: "Профиль")
        view.displayInitialData(viewModel: viewModel)
    }
}
