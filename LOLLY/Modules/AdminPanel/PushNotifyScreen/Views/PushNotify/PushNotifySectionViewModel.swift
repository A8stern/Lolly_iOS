//
//  PushNotifySectionViewModel.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

import UIKit

public struct TextFieldInputViewModel: Changeable {
    var title: String
    var placeholder: String
    var keyboardType: UIKeyboardType
    var maxLength: Int
}

public struct PushNotifySectionViewModel: Changeable {
    var titleInputViewModel: TextFieldInputViewModel
    var textInputViewModel: TextFieldInputViewModel
    var confirmButtonViewModel: ButtonViewModel
}
