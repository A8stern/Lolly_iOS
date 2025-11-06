//
//  PhoneLogInModels.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

enum PhoneLogInModels {
    enum InitialData {
        struct Response { }

        struct ViewModel {
            let continueButtonViewModel: ButtonViewModel?
            let isContinueButtonEnabled: Bool
            let isNameTextFieldHidden: Bool
            let isPrivacyCheckBoxHidden: Bool
            let onPrivacyCheckboxTap: () -> Void
        }
    }

    enum Registration {
        struct Response { }

        struct ViewModel {
            let phone: String
            let phoneTextFieldState: TextFieldState
            let continueButtonTitle: String
            let isContinueButtonEnabled: Bool
            let isNameTextFieldHidden: Bool
            let isPrivacyCheckBoxHidden: Bool
        }
    }

    enum ContinueButton {
        struct Response { }

        struct ViewModel {
            let isEnabled: Bool
        }
    }

    enum PhoneField {
        struct Response { }

        struct ViewModel {
            let phone: String
            let state: TextFieldState
            let caption: String
        }
    }

    enum NameField {
        struct Response { }

        struct ViewModel {
            let name: String
            let state: TextFieldState
            let caption: String
        }
    }
}
