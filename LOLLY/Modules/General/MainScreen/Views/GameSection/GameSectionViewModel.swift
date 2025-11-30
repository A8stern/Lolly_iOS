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
    public let waveformImageUrl: URL?

    public init(
        isSkeletonable: Bool = false,
        title: String? = nil,
        waveformImageUrl: URL? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.title = title
        self.waveformImageUrl = waveformImageUrl
    }
}
