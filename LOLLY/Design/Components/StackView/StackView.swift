//
//  StackView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.10.2025.
//

import UIKit

public final class StackView: UIStackView {
    @available(*, unavailable, message: "spacing not available, use space")
    override public var spacing: CGFloat { willSet { } }

    public var space: CGFloat {
        didSet {
            super.spacing = space
        }
    }

    // MARK: - Initializers

    public init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        space: CGFloat = .zero
    ) {
        self.space = space
        super.init(frame: .zero)
        self.axis = axis

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    @available(*, unavailable, message: "use setCustomSpace")
    override public func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        super.setCustomSpacing(spacing, after: arrangedSubview)
    }

    @available(*, unavailable, message: "use addArrangedSubview")
    override public func addSubview(_ view: UIView) {
        super.addSubview(view)
    }

    public func setCustomSpace(_ space: CGFloat, after: UIView? = nil) {
        let view: UIView = {
            if let after {
                return after
            } else if let lastSubview = arrangedSubviews.last {
                return lastSubview
            }
            return UIView()
        }()
        super.setCustomSpacing(space, after: view)
    }

    public func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }

    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}

// MARK: - ViewConfigurable

public extension StackView {
    func setupLayout() {
        super.spacing = space
    }

    func setupUI() { }

    func setupBehaviour() { }

    func updateUI() { }
}

// MARK: - Contentable

extension StackView: Contentable {
    public static let contentInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
}
