//
//  IntrinsicCollectionView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

import UIKit

open class IntrinsicCollectionView: UICollectionView {
    // MARK: - Lifecycle

    override public var intrinsicContentSize: CGSize {
        collectionViewLayout.collectionViewContentSize
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
