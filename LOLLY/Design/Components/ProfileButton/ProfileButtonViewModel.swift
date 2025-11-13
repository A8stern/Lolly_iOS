//
//  ProfileButtonViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

import UIKit

public struct ProfileButtonViewModel: Changeable {
    public var tapHandler: (() -> Void)?

    public init(tapHandler: (() -> Void)?) {
        self.tapHandler = tapHandler
    }
}
