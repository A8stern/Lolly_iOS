//
//  FontUtility.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

import UIKit

public final class FontUtility {
    public static var current: FontFamily = .ttTravels
    static func font(weight: FontWeight, size: CGFloat) -> UIFont {
        switch current {
        case .ttTravels:
            switch weight {
                case .regular: return Fonts.TTTravels.regular.font(size: size)
                case .medium: return Fonts.TTTravels.medium.font(size: size)
                case .demiBold: return Fonts.TTTravels.demiBold.font(size: size)
                case .bold: return Fonts.TTTravels.bold.font(size: size)
            }

        case .unbounded:
            switch weight {
                case .regular: return Fonts.Unbounded.regular.font(size: size)
                case .medium: return Fonts.Unbounded.medium.font(size: size)
                case .demiBold: return Fonts.Unbounded.semiBold.font(size: size)
                case .bold: return Fonts.Unbounded.bold.font(size: size)
            }
        }
    }
}
