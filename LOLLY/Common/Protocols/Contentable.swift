//
//  Contentable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

import UIKit

public protocol Contentable: UIView {
    static var contentInsets: UIEdgeInsets { get }
}
