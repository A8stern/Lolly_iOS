//
//  PromoSectionViewModel.swift
//  LOLLY
//
//  Created by Nikita on 03.11.2025.
//

import UIKit

public struct PromoSectionViewModel: Changeable {
    public let isSkeletonable: Bool
    public let text: String?

    public init(
        isSkeletonable: Bool = false,
        text: String? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.text = text
    }
}
