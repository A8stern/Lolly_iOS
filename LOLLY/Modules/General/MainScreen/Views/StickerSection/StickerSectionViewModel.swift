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
    public let newStickerImage: UIImage?
    public let buttonViewModel: ButtonViewModel?
    public let onTap: (() -> Void)?

    public init(
        isSkeletonable: Bool = false,
        title: String? = nil,
        sign: Character? = nil,
        stickersCount: Int? = nil,
        newStickerImage: UIImage? = nil,
        buttonViewModel: ButtonViewModel? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.title = title
        self.sign = sign
        self.stickersCount = stickersCount
        self.newStickerImage = newStickerImage
        self.buttonViewModel = buttonViewModel
        self.onTap = onTap
    }
}
