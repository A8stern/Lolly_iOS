//
//  SliderCardModel.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 19.11.2025.
//

import Foundation

public struct SliderCard {
    public let imageUrl: String
    public let text: String

    public init(imageUrl: String, text: String) {
        self.imageUrl = imageUrl
        self.text = text
    }

    init(model: SliderCardResponseModel) {
        self.imageUrl = model.imageURL
        self.text = model.text
    }
}
