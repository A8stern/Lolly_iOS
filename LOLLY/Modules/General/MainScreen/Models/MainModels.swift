//
//  AuthMethodsModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

enum MainModels {
    enum InitialData {
        struct Response { }

        struct ViewModel {
            let stickerSectionViewModel: StickerSectionViewModel?
            let calendarSectionViewModel: CalendarSectionViewModel?
            let contactsSectionViewModel: ContactsSectionViewModel?
        }
    }
}
