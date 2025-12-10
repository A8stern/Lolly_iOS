//
//  StickerSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

import UIKit

public struct StickerSectionViewModel: Changeable {
    public let isSkeletonable: Bool
    public let title: String?
    public let sign: Character?
    public let stickersCount: Int?
    public let stickersTotal: Int?
    public let newStickerImage: URL?
    public let cardStickerImages: [URL]
    public let buttonViewModel: ButtonViewModel?
    public let onTap: (() -> Void)?

    public init(
        isSkeletonable: Bool = false,
        title: String? = nil,
        sign: Character? = nil,
        stickersCount: Int? = nil,
        stickersTotal: Int? = nil,
        newStickerImage: URL? = nil,
        cardStickerImages: [URL] = [],
        buttonViewModel: ButtonViewModel? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.title = title
        self.sign = sign
        self.stickersCount = stickersCount
        self.stickersTotal = stickersTotal
        self.newStickerImage = newStickerImage
        self.cardStickerImages = cardStickerImages
        self.buttonViewModel = buttonViewModel
        self.onTap = onTap
    }
}
