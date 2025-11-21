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
    let largeStickerURL: [String]
    let smallStickerURL: [String]
    let userInternalId: String

    public init(count: Int, total: Int, largeStickerURL: [String], smallStickerURL: [String], userInternalId: String) {
        self.count = count
        self.total = total
        self.largeStickerURL = largeStickerURL
        self.smallStickerURL = smallStickerURL
        self.userInternalId = userInternalId
    }
}
