//
//  Skeletonable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//

private import SkeletonView
import UIKit

public protocol Skeletonable {
    /// Включает `isSkeletonable` для текущей вью и всех супервью до тех пор пока не обратится к вызывателю
    /// `SkeletonCallable`
    func enableSkeleton(caller: SkeletonCallable)
}

extension UIView: @preconcurrency Skeletonable {
    @MainActor
    public func enableSkeleton(caller: SkeletonCallable) {
        var rootView: UIView = self
        while rootView != caller {
            rootView.isSkeletonable = true
            guard let rootSuperview = rootView.superview else {
                print("Incorrect skeletonable hierarchy")
                return
            }
            rootView = rootSuperview
        }
    }
}
