//
//  ProfileModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

enum ProfileModels {
    enum InitialData {
        struct Response { }

        struct ViewModel {
            let title: String
        }
    }

    enum ProfileInfo {
        struct Response {
            let name: String
            let phone: String
        }

        struct ViewModel {
            let name: String
            let phone: String
        }
    }
}
