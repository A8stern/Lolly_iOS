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
    func onViewDidLoad() { }

    func onViewWillAppear() {
        responseInitialData()

        requestStickerStatus()
        requestMarketingAfisha()
        requestMarketingSlider()
        requestCalendarOverview()
        requestGamificationOverview()
        requestOrganizationInformation()
    }

    func onViewDidAppear() { }

    func onGameSectionTap() {
        coordinator.showGameSurvey()
    }
}

// MARK: - Private Methods

extension MainViewPresenter {
    fileprivate func requestStickerStatus() {
        // TODO: Запрос в сервис
        // view.displayStickerSection(viewModel: MainModels.Stickers.ViewModel)
        // либо передать ...(viewModel: nil), чтобы скрыть секцию
    }

    fileprivate func requestMarketingSlider() { }

    fileprivate func requestMarketingAfisha() {
        // TODO: Запрос в сервис
        // view.displayPromoSectionState(viewModel: MainModels.Promo.ViewModel)
        // либо передать ...(viewModel: nil), чтобы скрыть секцию
    }

    fileprivate func requestCalendarOverview() {
        // TODO: Запрос в сервис
        // view.displayCalendarSectionState(viewModel: MainModels.Calendar.ViewModel)
        // либо передать ...(viewModel: nil), чтобы скрыть секцию
    }

    fileprivate func requestGamificationOverview() {
        // TODO: Запрос в сервис
        // view.displayGameSectionState(viewModel: MainModels.Gamification.ViewModel)
        // либо передать ...(viewModel: nil), чтобы скрыть секцию
    }

    fileprivate func requestOrganizationInformation() {
        Task {
            do {
                let contacts = try await mainService.getContactsData()
                await MainActor.run {
                    let contactsSectionViewModel = makeContactsSectionViewModel(from: contacts)
                    let viewModel = MainModels.Contacts.ViewModel(
                        contactsSectionViewModel: contactsSectionViewModel
                    )
                    view.displayContactsSectionState(viewModel: viewModel)
                }
            } catch {
                await MainActor.run {
                    let viewModel = MainModels.Contacts.ViewModel(contactsSectionViewModel: nil)
                    view.displayContactsSectionState(viewModel: viewModel)
                }
            }
        }
    }

    fileprivate func responseInitialData() {
        let viewModel = MainModels.InitialData.ViewModel(
            title: L10n.Main.title,
            profileButtonViewModel: makeProfileButtonViewModel(),
            stickerSectionViewModel: StickerSectionViewModel(isSkeletonable: true),
            promoSectionViewModel: PromoSectionViewModel(isSkeletonable: true),
            gameSectionViewModel: GameSectionViewModel(isSkeletonable: true),
            calendarSectionViewModel: CalendarSectionViewModel(isSkeletonable: true),
            contactsSectionViewModel: ContactsSectionViewModel(isSkeletonable: true)
        )

        view.displayInitialData(viewModel: viewModel)
    }

/*
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
*/

    fileprivate func makeContactsSectionViewModel(from contacts: ContactsInfo) -> ContactsSectionViewModel {
        ContactsSectionViewModel(
            title: contacts.title,
            backgroundImageURL: contacts.imageURL,
            addresses: contacts.places.map {
                AddressViewModel(address: $0.location, description: $0.text)
            },
            socialButtonViewModels: contacts.socialMedias.compactMap { socialMedia in
                guard let url = socialMedia.link else { return nil }
                return SocialCircleButtonViewModel(
                    iconURL: socialMedia.imageURL,
                    tapHandler: { [weak self] in
                        guard let self else { return }
                        coordinator.openInSafari(url: url)
                    }
                )
            },
            buttons: contacts.website.compactMap { website in
                guard let url = website.link else { return nil }
                return ButtonViewModel(
                    title: website.text,
                    type: .primary(nil),
                    size: .large,
                    tapHandler: { [weak self] in
                        guard let self else { return }
                        coordinator.openInSafari(url: url)
                    }
                )
            }
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
