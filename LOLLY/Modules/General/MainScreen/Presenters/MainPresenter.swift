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
    private let mainService: MainServiceInterface

    // MARK: - Initialization

    init(
        view: MainView,
        coordinator: GeneralCoordinator,
        mainService: MainServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.mainService = mainService
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

extension MainViewPresenter {
    fileprivate func responseInitialData(response _: MainModels.InitialData.Response) {
        let viewModel = MainModels.InitialData.ViewModel(
            profileButtonViewModel: makeProfileButtonViewModel(),
            stickerSectionViewModel: makeStickerSectionViewModel(),
            promoSectionViewModel: makePromoSectionViewModel(),
            gameSectionViewModel: makeGameSectionViewModel(),
            calendarSectionViewModel: makeCalendarSectionViewModel(),
            contactsSectionViewModel: makeContactsSectionViewModel()
        )

        view.displayInitialData(viewModel: viewModel)
    }

    fileprivate func makeStickerSectionViewModel() -> StickerSectionViewModel? {
        StickerSectionViewModel(
            title: "Карточка заполнена",
            sign: "=",
            stickersCount: 6,
            newStickerImage: Assets.Brand.Stickers.stickerLarge.image,
            buttonViewModel: ButtonViewModel(
                title: "Получить напиток",
                type: .custom(.yellow),
                size: .medium,
                tapHandler: { [weak self] in
                    guard let self else { return }
                    coordinator.showScanner()
                }
            )
        )
    }

    fileprivate func makeCalendarSectionViewModel() -> CalendarSectionViewModel? {
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

    fileprivate func makeGameSectionViewModel() -> GameSectionViewModel? {
        return GameSectionViewModel(
            title: L10n.Main.GameSection.title,
            waveformImage: Assets.Brand.Gamification.waveform.image
        )
    }

    fileprivate func makePromoSectionViewModel() -> PromoSectionViewModel? {
        return PromoSectionViewModel(
            text: "Скидка -20% в день рождения"
        )
    }

    fileprivate func makeContactsSectionViewModel() -> ContactsSectionViewModel? {
        ContactsSectionViewModel(
            title: "Ждём вас",
            backgroundImage: Assets.Brand.Photos.contactsBackground.image,
            addresses: [
                AddressViewModel(address: "Ленина, 10", description: "11:00 - 22:00"),
                AddressViewModel(address: "Пр. Карла Маркса, 47", description: "11:00 - 22:00"),
                AddressViewModel(address: "Мичурина, 12", description: "11:00 - 22:00"),
                AddressViewModel(address: "Ленина, 3", description: "12:00 - 22:00")
            ],
            socialButtonViewModels: [
                SocialCircleButtonViewModel(
                    iconURL: "https://i.yapx.ru/cGYdW.png",
                    tapHandler: { [weak self] in
                        guard let self else { return }
                        guard let url = URL(string: "https://facebook.com/") else { return }
                        coordinator.openInSafari(url: url)
                    }
                ),
                SocialCircleButtonViewModel(
                    iconURL: "https://i.yapx.ru/cGYiz.png",
                    tapHandler: { [weak self] in
                        guard let self else { return }
                        guard let url = URL(string: "https://vk.com/") else { return }
                        coordinator.openInSafari(url: url)
                    }
                ),
                SocialCircleButtonViewModel(
                    iconURL: "https://i.yapx.ru/cGYjI.png",
                    tapHandler: { [weak self] in
                        guard let self else { return }
                        guard let url = URL(string: "https://instagram.com/") else { return }
                        coordinator.openInSafari(url: url)
                    }
                )
            ],
            websiteButton: ButtonViewModel(
                title: L10n.Main.ContactsSection.website,
                type: .primary(nil),
                size: .large,
                tapHandler: { [weak self] in
                    guard let self else { return }
                    guard let webSiteURL = URL(string: "https://harucha.ru") else { return }
                    coordinator.openInSafari(url: webSiteURL)
                }
            )
        )
    }

    fileprivate func makeProfileButtonViewModel() -> ProfileButtonViewModel {
        ProfileButtonViewModel(tapHandler: { [weak self] in
            guard let self else { return }
            coordinator.showProfile()
        })
    }
}

// MARK: - ButtonViewModel.Config

extension ButtonViewModel.Config {
    public static let yellow: ButtonViewModel.Config = .init(
        icon: .none,
        imageTintColor: Colors.Text.primary,
        contentColor: Colors.Text.primary,
        enabledColor: Colors.Constants.yellow,
        pressedColor: Colors.Constants.ocher,
        disabledColor: Colors.Constants.grey,
        needImageTint: true
    )
}
