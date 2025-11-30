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
    private let calendarFormatter: CalendarFormatterInterface

    private var calendarDays: [Day] = []

    // MARK: - Initialization

    init(
        view: MainView,
        coordinator: GeneralCoordinator,
        mainService: MainServiceInterface,
        calendarFormatter: CalendarFormatterInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.mainService = mainService
        self.calendarFormatter = calendarFormatter
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
        Task {
            do {
                let loyaltyStatus = try await mainService.getLoyaltyStatus()
                await MainActor.run {
                    let promoSectionViewModel = makeStickerSectionViewModel(from: loyaltyStatus)
                    let viewModel = MainModels.Stickers.ViewModel(
                        stickerSectionViewModel: promoSectionViewModel
                    )
                    view.displayStickerSection(viewModel: viewModel)
                }
            } catch {
                await MainActor.run {
                    let viewModel = MainModels.Stickers.ViewModel(stickerSectionViewModel: nil)
                    view.displayStickerSection(viewModel: viewModel)
                }
            }
        }
    }

    fileprivate func requestMarketingSlider() { }

    fileprivate func requestMarketingAfisha() {
        Task {
            do {
                let text = try await mainService.getAfisha()
                await MainActor.run {
                    let promoSectionViewModel = makePromoSectionViewModel(from: text)
                    let viewModel = MainModels.Promo.ViewModel(
                        promoSectionViewModel: promoSectionViewModel
                    )
                    view.displayPromoSectionState(viewModel: viewModel)
                }
            } catch {
                await MainActor.run {
                    let viewModel = MainModels.Promo.ViewModel(promoSectionViewModel: nil)
                    view.displayPromoSectionState(viewModel: viewModel)
                }
            }
        }
    }

    fileprivate func requestCalendarOverview() {
        Task {
            do {
                let days = try await mainService.getCalendarOverview()
                await MainActor.run {
                    calendarDays = days
                    requestCalendarDaysUpdate()
                }
            } catch {
                await MainActor.run {
                    let viewModel = MainModels.Calendar.ViewModel(calendarSectionViewModel: nil)
                    view.displayCalendarSectionState(viewModel: viewModel)
                }
            }
        }
    }

    fileprivate func requestGamificationOverview() {
        Task {
            do {
                let overview = try await mainService.getGamifacitaionOverview()
                await MainActor.run {
                    let gameSectionViewModel = makeGameSectionViewModel(from: overview)
                    let viewModel = MainModels.Gamification.ViewModel(
                        gameSectionViewModel: gameSectionViewModel
                    )
                    view.displayGameSectionState(viewModel: viewModel)
                }
            } catch {
                await MainActor.run {
                    let viewModel = MainModels.Gamification.ViewModel(gameSectionViewModel: nil)
                    view.displayGameSectionState(viewModel: viewModel)
                }
            }
        }
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

    fileprivate func makeStickerSectionViewModel(from status: LoyaltyStatus) -> StickerSectionViewModel? {
        StickerSectionViewModel(
            title: status.count == status.total ?
                L10n.Main.StickerSection.cardIsFull
                : L10n.Main.StickerSection.addSticker,
            sign: status.count == status.total ?
                Character(L10n.Main.StickerSection.Sign.equal)
                : Character(L10n.Main.StickerSection.Sign.plus),
            stickersCount: status.count,
            newStickerImage: Assets.Brand.Stickers.stickerLarge.image,
            buttonViewModel: ButtonViewModel(
                title: L10n.Main.StickerSection.getDrink,
                type: .custom(.yellow),
                size: .medium,
                tapHandler: { [weak self] in
                    guard let self else { return }
                    coordinator.showScanner()
                }
            )
        )
    }

    fileprivate func makeCalendarSectionViewModel(from days: [Day], selected selectedDay: Day? = nil) -> CalendarSectionViewModel? {
        guard !days.isEmpty else { return nil }
        guard let firstDate = days.first?.date else { return nil }

        let month = calendarFormatter.getFormattedString(
            from: firstDate,
            format: .month
        ).capitalized

        let cellViewModels = days.map { day in
            let type = calendarFormatter.getDayType(from: day.date)
            let formattedDay = calendarFormatter.getFormattedString(from: day.date, format: .day)

            return CalendarCellViewModel(
                rawDate: day.date,
                date: formattedDay,
                type: type,
                isSelected: day == selectedDay
            )
        }

        let eventViewModel: EventViewModel? = {
            let currentDay = days.first { day in
                let type = calendarFormatter.getDayType(from: day.date)
                return type == .current
            }
            guard let dayOfEvent: Day = selectedDay ?? currentDay else { return nil }
            guard let firstEvent = dayOfEvent.events.first else { return nil }

            let eventTitle = calendarFormatter.getFormattedString(
                from: dayOfEvent.date,
                format: .weekHourMinutes
            )

            return EventViewModel(
                title: eventTitle,
                subtitle: firstEvent.name,
                onTap: nil
            )
        }()

        return CalendarSectionViewModel(
            month: month,
            days: cellViewModels,
            event: eventViewModel,
            onDayTap: { [weak self] date in
                guard let self else { return }
                guard let selectedDay = days.first(where: { $0.date == date }) else { return }
                requestCalendarDaysUpdate(selectedDay: selectedDay)
            }
        )
    }

    fileprivate func requestCalendarDaysUpdate(selectedDay: Day? = nil) {
        let calendarSectionViewModel = makeCalendarSectionViewModel(from: calendarDays, selected: selectedDay)
        let viewModel = MainModels.Calendar.ViewModel(
            calendarSectionViewModel: calendarSectionViewModel
        )
        view.displayCalendarSectionState(viewModel: viewModel)
    }

    fileprivate func makePromoSectionViewModel(from text: String) -> PromoSectionViewModel? {
        return PromoSectionViewModel(
            text: text
        )
    }

    fileprivate func makeGameSectionViewModel(from overview: GamificationOverview) -> GameSectionViewModel {
        GameSectionViewModel(
            isSkeletonable: false,
            title: overview.text,
            waveformImage: Assets.Brand.Gamification.waveform.image
        )
    }

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
