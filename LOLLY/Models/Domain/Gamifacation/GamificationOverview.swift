//
//  GamificationOverviewModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 19.11.2025.
//

import Foundation

public struct GamificationOverview {
    public let text: String
    public let imageUrl: String

    public init(text: String, imageUrl: String) {
        self.text = text
        self.imageUrl = imageUrl
    }
}
