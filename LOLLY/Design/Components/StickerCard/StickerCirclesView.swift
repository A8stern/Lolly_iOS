//
//  StickerCirclesView.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 26.11.2025.
//

private import SnapKit
import UIKit

final class StickerCirclesView: UIView {
    var totalStickers: Int = 0 {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }
    var filledStickers: Int = 0 {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }

    var images: [UIImage?] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.Stickers.background.color
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StickerCircleCell.self, forCellWithReuseIdentifier: StickerCircleCell.reuseIdentifier)
        collectionView.semanticContentAttribute = .forceRightToLeft
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StickerCirclesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalStickers
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StickerCircleCell.reuseIdentifier,
            for: indexPath
        ) as? StickerCircleCell else {
            return UICollectionViewCell()
        }
        if indexPath.item < images.count {
            cell.configure(image: images[indexPath.item])
        } else {
            cell.configure(image: nil)
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemSize = collectionView.bounds.height / 110 * 35
        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: collectionView.bounds.height / 110 * 12.5,
            left: collectionView.bounds.width / 194 * 20.5,
            bottom: collectionView.bounds.height / 110 * 12.5,
            right: collectionView.bounds.width / 194 * 20.5
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionView.bounds.width / 194 * 20
    }
}
