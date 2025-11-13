//
//  SocialCircleButtonViewModel.swift
//  LOLLY
//
//  Created by Nikita on 11.11.2025.
//
import UIKit

public struct SocialCircleButtonViewModel: Changeable {
    var iconURL: String
    var tapHandler: (() -> Void)?

    public init(
        iconURL: String,
        tapHandler: (() -> Void)?
    ) {
        self.iconURL = iconURL
        self.tapHandler = tapHandler
    }
}
