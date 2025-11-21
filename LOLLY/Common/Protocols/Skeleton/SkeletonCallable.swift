//
//  SkeletonCallable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 21.11.2025.
//


private import SkeletonView
import UIKit

public protocol SkeletonCallable: Skeletonable where Self: UIView {
    /// Подготовительный метод перед началом показа анимации.
    /// Здесь необходимо указать какие конечные view должны показывать анимацию скелетонов. Задается через
    /// `enableSkeleton(caller: )`
    /// Вызывается внутри `displaySkeleton()`
    /// Не рекомендуется вызывать мануально
    func prepareForDisplaySkeleton()

    /// Показ скелетонов рекурсивно.
    /// Вызывается мануально.
    /// Для включения каждая дочерняя вью, задействованная в анимации должна наследовать `SkeletonCallable`
    func displaySkeleton()

    /// Подготовительный метод перед сокрытие показа скелетонов.
    /// Вызывается внутри `dismissSkeleton()`
    /// Не рекомендуется вызывать мануально
    func prepareForDismissSkeleton()

    /// Сокрытие показа скелетонов.
    /// Вызывается мануально.
    func dismissSkeleton()
}

// MARK: - SkeletonCallable defaults

extension SkeletonCallable {
    public func displaySkeleton() {
        isSkeletonable = true
        prepareForDisplaySkeleton()
        recursivePrepareForDisplaySkeleton()

        DispatchQueue.main.async {
            self.showAnimatedGradientSkeleton()
        }

        setNeedsLayout()
        lolly_layoutIfVisible()
    }

    public func dismissSkeleton() {
        prepareForDismissSkeleton()
        recursivePrepareForDismissSkeleton()

        DispatchQueue.main.async {
            self.hideSkeleton()
        }

        setNeedsLayout()
        lolly_layoutIfVisible()
    }
}

// MARK: - Helpers for SkeletonCallable

extension UIView {
    fileprivate func recursivePrepareForDisplaySkeleton() {
        subviews
            .compactMap { $0 as? UIView & SkeletonCallable }
            .forEach {
                $0.isSkeletonable = true
                $0.prepareForDisplaySkeleton()
                $0.setNeedsLayout()
                $0.lolly_layoutIfVisible()
            }
        subviews
            .forEach { $0.recursivePrepareForDisplaySkeleton() }
    }

    fileprivate func recursivePrepareForDismissSkeleton() {
        subviews
            .compactMap { $0 as? UIView & SkeletonCallable }
            .forEach {
                $0.prepareForDismissSkeleton()
                $0.setNeedsLayout()
                $0.lolly_layoutIfVisible()
            }
        subviews
            .forEach { $0.recursivePrepareForDismissSkeleton() }
    }
}

