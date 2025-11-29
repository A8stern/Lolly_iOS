//
//  StickerCard.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

private import SnapKit
import UIKit

public final class StickerCard: UIView, ViewModellable {
    public typealias ViewModel = StickerCardViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var blurView: BlurView = {
        let view = BlurView()
        return view
    }()

    private lazy var circlesView: StickerCirclesView = {
        let view = StickerCirclesView()
        return view
    }()

    // MARK: - Init

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfigurable

extension StickerCard {
    public func setupLayout() {
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(circlesView)
        circlesView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().inset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().inset(0)
        }
    }

    public func setupUI() {
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 9.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .clear

        updateUI()
    }

    public func updateUI() {
        guard let viewModel else {
            circlesView.totalStickers = 0
            circlesView.filledStickers = 0
            circlesView.images = []
            circlesView.setNeedsLayout()
            circlesView.layoutIfNeeded()
            return
        }
        circlesView.totalStickers = viewModel.totalStickers
        circlesView.filledStickers = viewModel.stickerCount
        circlesView.images = viewModel.stickersImages
        circlesView.setNeedsLayout()
        circlesView.layoutIfNeeded()
    }
}

extension StickerCard {
    fileprivate enum Constants { }
}
