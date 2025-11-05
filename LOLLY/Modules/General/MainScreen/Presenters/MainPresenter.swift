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

    /// Нажатие на блок геймификации
    func onGameSectionTap()
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

    func onGameSectionTap() {
        coordinator.showGameSurvey()
    }
}

// MARK: - Private Methods

private extension MainViewPresenter {
    func responseInitialData(response: MainModels.InitialData.Response) {
        let viewModel = MainModels.InitialData.ViewModel(
            stickerSectionViewModel: makeStickerSectionViewModel(),
            promoSectionViewModel: makePromoSectionViewModel(),
            gameSectionViewModel: makeGameSectionViewModel(),
            calendarSectionViewModel: makeCalendarSectionViewModel(),
            contactsSectionViewModel: makeContactsSectionViewModel()
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
                subtitle: "Harucha BDay Party",
                onTap: nil
            )
        )
    }

    func makeGameSectionViewModel() -> GameSectionViewModel? {
        return GameSectionViewModel(
            title: L10n.Main.GameSection.title,
            waveformImage: Assets.Brand.Gamification.waveform.image
        )
    }

    func makePromoSectionViewModel() -> PromoSectionViewModel? {
        return PromoSectionViewModel(
            text: "Скидка -20% в день рождения"
        )
    }

    func makeContactsSectionViewModel() -> ContactsSectionViewModel? {
        ContactsSectionViewModel(
            title: "Ждём вас",
            backgroundImage: Assets.Brand.Photos.contactsBackground.image,
            addresses: [
                AddressViewModel(address: "Ленина, 10", description: "11:00 - 22:00"),
                AddressViewModel(address: "Пр. Карла Маркса, 47", description: "11:00 - 22:00"),
                AddressViewModel(address: "Мичурина, 12", description: "11:00 - 22:00"),
                AddressViewModel(address: "Ленина, 3", description: "12:00 - 22:00")
            ]
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
