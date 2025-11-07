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

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupLayout()
        setupUI()
        setupBehaviour()
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
    }

    public func setupUI() {
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 9.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .clear

        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        // isHidden = viewModel == nil
        // guard let viewModel else { return }
    }
}

extension StickerCard {
    fileprivate enum Constants { }
}
