//
//  SocialCircleButtonViewModel.swift
//  LOLLY
//
//  Created by Nikita on 11.11.2025.
//

import UIKit

public struct SocialCircleButtonViewModel: Changeable {
    var iconURL: URL?
    var tapHandler: (() -> Void)?

    public init(
        iconURL: URL?,
        tapHandler: (() -> Void)?
    ) {
        self.iconURL = iconURL
        self.tapHandler = tapHandler
    }
}
