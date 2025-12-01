//
//  PhotoPermissionPresenter.swift
//  Brewsell
//
//  Created by Kovalev Gleb on 29.11.2025.
//

import UIKit

protocol PhotoPermissionPresenter: AnyObject {
    func onViewDidLoad()
    func onCloseTap()
}

final class PhotoPermissionViewPresenter {
    private unowned let view: PhotoPermissionView
    private let coordinator: AdminCoordinator

    init(
        view: PhotoPermissionView,
        coordinator: AdminCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

extension PhotoPermissionViewPresenter: PhotoPermissionPresenter {
    func onViewDidLoad() {
        checkChanges()
    }

    func onCloseTap() {
        Task { @MainActor in
            coordinator.closePush()
        }
    }
}

extension PhotoPermissionViewPresenter {
    fileprivate func checkChanges() {}
}
