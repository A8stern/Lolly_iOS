//
//  MainModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

enum MainModels {
    enum InitialData {
        struct Response { }

        struct ViewModel {
            let profileButtonViewModel: ProfileButtonViewModel
            let stickerSectionViewModel: StickerSectionViewModel?
            let promoSectionViewModel: PromoSectionViewModel?
            let gameSectionViewModel: GameSectionViewModel?
            let calendarSectionViewModel: CalendarSectionViewModel?
            let contactsSectionViewModel: ContactsSectionViewModel?
        }
    }
}
