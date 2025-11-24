//
//  SectionButtonViewModel.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

import UIKit

public struct SectionButtonViewModel: Changeable {
    var iconAsset: ImageAsset
    var text: String
    var tapHandler: (() -> Void)?

    public init(
        iconAsset: ImageAsset,
        text: String,
        tapHandler: (() -> Void)?
    ) {
        self.iconAsset = iconAsset
        self.text = text
        self.tapHandler = tapHandler
    }
}
