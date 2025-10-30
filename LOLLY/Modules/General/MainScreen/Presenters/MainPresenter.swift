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
    func onViewDidLoad() {
        let response = MainModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }
}

// MARK: - Private Methods

private extension MainViewPresenter {
    func responseInitialData(response: MainModels.InitialData.Response) {
        let viewModel = MainModels.InitialData.ViewModel(
            stickerSectionViewModel: makeStickerSectionViewModel(),
            calendarSectionViewModel: makeCalendarSectionViewModel()
        )

        view.displayInitialData(viewModel: viewModel)
    }

    func makeStickerSectionViewModel() -> StickerSectionViewModel? {
        StickerSectionViewModel(
            title: "Карточка заполнена",
            sign: "=",
            stickersCount: 6,
            newStickerImage: Assets.Brand.Stickers.stickerLarge.image,
            buttonViewModel: ButtonViewModel(
                title: "Получить напиток",
                type: .custom(.yellow),
                size: .medium,
                tapHandler: nil
            )
        )
    }

    func makeCalendarSectionViewModel() -> CalendarSectionViewModel? {
        CalendarSectionViewModel(
            month: "Май",
            days: [
                CalendarCellViewModel(date: 24, type: .past),
                CalendarCellViewModel(date: 25, type: .past),
                CalendarCellViewModel(date: 26, type: .current),
                CalendarCellViewModel(date: 27, type: .future),
                CalendarCellViewModel(date: 28, type: .future),
                CalendarCellViewModel(date: 29, type: .future),
                CalendarCellViewModel(date: 30, type: .future),
                CalendarCellViewModel(date: 31, type: .future)
            ],
            event: EventViewModel(
                title: "Воскресенье, 13:00",
                subtitle: "Harucha BDay Party"
            )
        )
    }
}

// MARK: - ButtonViewModel.Config

public extension ButtonViewModel.Config {
    static let yellow: ButtonViewModel.Config = {
        ButtonViewModel.Config(
            icon: .none,
            imageTintColor: Colors.Text.primary,
            contentColor: Colors.Text.primary,
            enabledColor: Colors.Constants.yellow,
            pressedColor: Colors.Constants.ocher,
            disabledColor: Colors.Constants.grey,
            needImageTint: true
        )
    }()
}
