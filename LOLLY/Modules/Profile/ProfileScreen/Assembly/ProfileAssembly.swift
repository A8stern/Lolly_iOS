//
//  ProfileAssembly.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

@MainActor
final class ProfileAssembly: Assembly {
    // MARK: - Private Properties

    private lazy var serviceAssembly: ServiceAssembly = self.context.assembly()

    // MARK: - Internal Methods

    func assembleModule(
        coordinator: ProfileCoordinator
    ) -> ProfileViewController {
        return define(scope: .prototype, init: ProfileViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

// MARK: Private Methods

extension ProfileAssembly {
    fileprivate func assemblePresenter(
        view: ProfileView,
        coordinator: ProfileCoordinator
    ) -> ProfilePresenter {
        return define(
            scope: .prototype,
            init: ProfileViewPresenter(
                view: view,
                coordinator: coordinator,
                profileService: self.serviceAssembly.profileService
            )
        )
    }
}
