//
//  StickerCircleCell.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 26.11.2025.
//

import Kingfisher
private import SnapKit
import UIKit

final class StickerCircleCell: UICollectionViewCell {
    static let reuseIdentifier = "StickerCircleCell"

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Stickers.place.color
        view.clipsToBounds = true
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.tintColor = .white
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        circleView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(link: URL?) {
        imageView.kf.setImage(with: link)
    }
}
