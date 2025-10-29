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

    private lazy var blurView: UIVisualEffectView = {
        let effect: UIVisualEffect = {
            if #available(iOS 26.0, *) {
                return UIGlassEffect(style: .regular)
            } else {
                return UIBlurEffect(style: .systemMaterial)
            }
        }()
        let view = UIVisualEffectView(effect: effect)
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfigurable

public extension StickerCard {
    func setupLayout() {
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupUI() {
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 9.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .clear

        updateUI()
    }

    func setupBehaviour() { }

    func updateUI() {
        // isHidden = viewModel == nil
        // guard let viewModel else { return }
    }
}

private extension StickerCard {
    enum Constants { }
}
