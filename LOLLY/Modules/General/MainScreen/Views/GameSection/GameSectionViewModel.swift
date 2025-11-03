//
//  GameSectionViewModel.swift
//  LOLLY
//
//  Created by Егор on 29.10.2025.
//

import UIKit

public struct GameSectionViewModel: Changeable {
    public let title: String
    public let waveformImage: UIImage
    public init(
        title: String,
        waveformImage: UIImage
    ){
        self.title = title
        self.waveformImage = waveformImage
    }
}
