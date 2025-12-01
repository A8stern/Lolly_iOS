//
//  PhotoPermissionAssembly.swift
//  Brewsell
//
//  Created by Kovalev Gleb on 29.11.2025.
//

internal import UIKit

final class PhotoPermissionAssembly: Assembly {
    private lazy var managerAssembly: ManagerAssembly = self.context.assembly()

    func assembleModule(coordinator: AdminCoordinator) -> PhotoPermissionViewController {
        return define(scope: .prototype, init: PhotoPermissionViewController()) { view in
            view.presenter = self.assemblePresenter(view: view, coordinator: coordinator)
            return view
        }
    }
}

extension PhotoPermissionAssembly {
    fileprivate func assemblePresenter(view: PhotoPermissionView, coordinator: AdminCoordinator) -> PhotoPermissionPresenter {
        return define(
            scope: .prototype,
            init: PhotoPermissionViewPresenter(
                view: view,
                coordinator: coordinator
            )
        )
    }
}
