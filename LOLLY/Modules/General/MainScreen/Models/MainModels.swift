//
//  MainModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

enum MainModels {
    enum InitialData {
        struct ViewModel {
            let title: String
            let profileButtonViewModel: ProfileButtonViewModel
            let stickerSectionViewModel: StickerSectionViewModel?
            let promoSectionViewModel: PromoSectionViewModel?
            let gameSectionViewModel: GameSectionViewModel?
            let calendarSectionViewModel: CalendarSectionViewModel?
            let contactsSectionViewModel: ContactsSectionViewModel?
        }
    }

    enum Stickers {
        struct ViewModel {
            let stickerSectionViewModel: StickerSectionViewModel?
        }
    }

    enum Promo {
        struct ViewModel {
            let promoSectionViewModel: PromoSectionViewModel?
        }
    }

    enum Gamification {
        struct ViewModel {
            let gameSectionViewModel: GameSectionViewModel?
        }
    }

    enum Calendar {
        struct ViewModel {
            let calendarSectionViewModel: CalendarSectionViewModel?
        }
    }

    enum Contacts {
        struct ViewModel {
            let contactsSectionViewModel: ContactsSectionViewModel?
        }
    }
}
