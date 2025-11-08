//
//  Fonts+Styles.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

import UIKit.UIFont

extension Fonts {
    public enum Styles {
        /// **Medium / 12.0**
        static var caption: UIFont {
            FontUtility.font(weight: .medium, size: 12)
        }

        /// **Demibold / 14.0**
        static var body: UIFont {
            FontUtility.font(weight: .demiBold, size: 14)
        }

        /// **Demibold / 16.0**
        static var title3: UIFont {
            FontUtility.font(weight: .demiBold, size: 16)
        }

        /// **SemiBold / 18.0**
        static var title2: UIFont {
            FontUtility.font(weight: .demiBold, size: 18)
        }

        /// **Bold / 24.0**
        static var title1: UIFont {
            FontUtility.font(weight: .bold, size: 24)
        }

        static func custom(weight: FontWeight, size: CGFloat) -> UIFont {
            FontUtility.font(weight: weight, size: size)
        }
    }
}
