//
//  AuthMethodsModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

enum AuthMethodsModels {
    enum InitialData {
        struct Response {
            let isPhoneAuthAvailable: Bool
            let isAppleAuthAvailable: Bool
        }

        struct ViewModel {
            let phoneSignInButtonViewModel: ButtonViewModel?
            let appleSignInButtonViewModel: ButtonViewModel?
            let conditions: String
        }
    }
}
