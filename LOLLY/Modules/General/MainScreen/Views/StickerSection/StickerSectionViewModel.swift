//
//  StickerSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

import UIKit

public struct StickerSectionViewModel: Changeable {
    public let title: String
    public let sign: Character
    public let stickersCount: Int
    public let newStickerImage: UIImage
    public let buttonViewModel: ButtonViewModel?

    public init(
        title: String,
        sign: Character,
        stickersCount: Int,
        newStickerImage: UIImage,
        buttonViewModel: ButtonViewModel?
    ) {
        self.title = title
        self.sign = sign
        self.stickersCount = stickersCount
        self.newStickerImage = newStickerImage
        self.buttonViewModel = buttonViewModel
    }
}
