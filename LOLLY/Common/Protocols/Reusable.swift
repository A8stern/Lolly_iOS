//
//  Reusable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

import UIKit

public protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    public static var reuseId: String {
        String(describing: self)
    }
}

extension UITableViewCell: Reusable { }

extension UICollectionViewCell: Reusable { }
