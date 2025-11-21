//
//  GameSectionViewModel.swift
//  LOLLY
//
//  Created by Егор on 29.10.2025.
//

import UIKit

public struct GameSectionViewModel: Changeable {
    public let isSkeletonable: Bool
    public let title: String?
    public let waveformImage: UIImage?

    public init(
        isSkeletonable: Bool = false,
        title: String? = nil,
        waveformImage: UIImage? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.title = title
        self.waveformImage = waveformImage
    }
}
