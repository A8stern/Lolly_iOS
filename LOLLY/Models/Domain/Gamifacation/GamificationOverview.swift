//
//  GamificationOverviewModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 19.11.2025.
//

import Foundation

public struct GamificationOverview {
    public let text: String
    public let imageUrl: URL?

    public init(text: String, imageUrl: URL?) {
        self.text = text
        self.imageUrl = imageUrl
    }
}
