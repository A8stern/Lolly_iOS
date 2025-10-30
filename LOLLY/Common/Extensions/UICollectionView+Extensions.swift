//
//  UICollectionView+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

import UIKit

public extension UICollectionView {
    /// Исправленная прокрутка к элементу по его индексу.
    /// Проблема: iOS 14.X неверно прокручивает коллекцию в некоторых случаях, из-за чего
    /// желаемый элемент может отобразиться в некорректной позиции.
    func patchedScrollToItem(
        at indexPath: IndexPath,
        at scrollPosition: UICollectionView.ScrollPosition,
        animated: Bool
    ) {
        if #available(iOS 15.0, *) {
            scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            return
        }
        guard let targetFrame = layoutAttributesForItem(at: indexPath)?.frame else {
            return
        }
        // Прокручиваем вручную до приблизительной позиции элемента
        scrollRectToVisible(targetFrame, animated: animated)
        // Просим коллекцию произвести перерасчет размеров (часть видимых ячеек
        // могут иметь неправильные размеры)
        setNeedsLayout()
        layoutIfNeeded()
        // Дополнительно прокручиваем коллекцию к элементу
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    /// Останавливает процесс прокрутки.
    func stopScrolling() {
        self.isScrollEnabled = false
        DispatchQueue.main.async {
            self.isScrollEnabled = true
        }
    }
}

public extension UICollectionView {
    /// Регистрирует класс ячейки для использования в `UICollectionView`
    ///
    /// - Parameter cellType: Тип ячейки, которая реализует протокол `Reusable`
    func registerCellClass<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseId)
    }

    /// Возвращает экземпляр переиспользуемой ячейки по ее типу.
    ///
    /// - Parameters:
    ///   - cellType: Тип ячейки (должна реализовывать протокол Reusable).
    ///   - indexPath: Index path.
    /// - Returns: Экземпляр ячейки.
    func dequeueReusableCell<T: UICollectionViewCell>(
        ofType cellType: T.Type,
        at indexPath: IndexPath
    ) -> T {
        guard
            let cell = dequeueReusableCell(
                withReuseIdentifier: cellType.reuseId,
                for: indexPath
            ) as? T
        else {
            assertionFailure("Не удалось найти ячейку с идентификатором \(cellType.reuseId)")
            return T()
        }
        return cell
    }

    /// Регистрирует класс view для использования в `UICollectionView`
    func registerSupplementaryClass<T: UICollectionReusableView>(
        _ viewType: T.Type,
        kind: String
    ) where T: Reusable {
        register(
            viewType,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: viewType.reuseId
        )
    }

    /// Возвращает экземпляр переиспользуемой view по ее типу.
    func dequeueReusableSupplementary<T: UICollectionReusableView>(
        ofType viewType: T.Type,
        kind: String,
        at indexPath: IndexPath
    ) -> T where T: Reusable {
        guard
            let view = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: viewType.reuseId,
                for: indexPath
            ) as? T
        else {
            assertionFailure("Не удалось найти view с идентификатором \(viewType.reuseId)")
            return T()
        }
        return view
    }
}
