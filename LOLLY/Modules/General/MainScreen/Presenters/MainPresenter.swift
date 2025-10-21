//
//  MainPresenter.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

protocol MainPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// События показа экрана
    func onViewWillAppear()

    /// Триггер загрузки данных
    func onViewDidAppear()
}

final class MainViewPresenter {
    // MARK: - Private Properties

    private unowned let view: MainView
    private let coordinator: GeneralCoordinator

    // MARK: - Initialization

    init(
        view: MainView,
        coordinator: GeneralCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - MainPresenter

extension MainViewPresenter: MainPresenter {
    func onViewDidLoad() { }

    func onViewWillAppear() { }

    func onViewDidAppear() { }
}

// MARK: - Private Methods

private extension MainViewPresenter { }
