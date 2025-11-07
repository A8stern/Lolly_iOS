//
//  OtpCodeModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

enum OtpCodeModels {
    enum ResendButton {
        struct Response { }

        struct ViewModel {
            let resendButtonTitle: String
            let isResendButtonEnabled: Bool
        }
    }
}
