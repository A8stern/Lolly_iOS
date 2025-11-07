//
//  CircleButtonViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 05.11.2025.
//

import UIKit

public struct CircleButtonViewModel: Changeable {
    public enum CircleButtonType {
        case play
    }

    public var type: CircleButtonType
    public var tapHandler: (() -> Void)?

    public init(
        type: CircleButtonType,
        tapHandler: (() -> Void)?
    ) {
        self.type = type
        self.tapHandler = tapHandler
    }
}

extension CircleButtonViewModel.CircleButtonType {
    var image: UIImage? {
        switch self {
            case .play:
                return UIImage(systemName: "play.fill")
        }
    }
}
