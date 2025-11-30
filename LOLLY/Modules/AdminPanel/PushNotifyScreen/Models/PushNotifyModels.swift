//
//  PushNotifyModels.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

enum PushNotifyModels {
    enum InitialData {
        struct Response { }

        struct ViewModel {
            let title: String
            let pushNotifyViewModel: PushNotifySectionViewModel?
        }
    }
}
