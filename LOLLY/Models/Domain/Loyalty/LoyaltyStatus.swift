//
//  LoyaltyStatusModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 19.11.2025.
//

import Foundation

public struct LoyaltyStatus {
    let count: Int
    let total: Int
    let largeStickerURL: URL?
    let smallStickersURL: [URL]
    let userInternalId: String

    public init(
        count: Int,
        total: Int,
        largeStickerURL: URL?,
        smallStickersURL: [URL],
        userInternalId: String
    ) {
        self.count = count
        self.total = total
        self.largeStickerURL = largeStickerURL
        self.smallStickersURL = smallStickersURL
        self.userInternalId = userInternalId
    }
}
