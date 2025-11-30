//
//  StickerCardViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

import UIKit

public struct StickerCardViewModel: Changeable {
    public var totalStickers: Int
    public var stickerCount: Int
    public var stickersImages: [UIImage?]

    public init(
        totalStickers: Int,
        stickerCount: Int,
        stickersImages: [UIImage?]
    ) {
        self.totalStickers = totalStickers
        self.stickerCount = stickerCount
        self.stickersImages = stickersImages
    }
}
