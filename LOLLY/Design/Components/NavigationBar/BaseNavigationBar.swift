//
//  BaseNavigationBar.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 28.10.2025.
//

private import SnapKit
import UIKit

public class BaseNavigationBar: UIView {
    // MARK: - Public Properties

    public var contentSize: CGFloat = Constants.contentSize {
        didSet {
            updateContentConstraints(newValue: contentSize)
        }
    }

    public var innerMargins = Constants.innerMargins {
        didSet {
            layoutMargins = innerMargins
            stackView.snp.remakeConstraints { make in
                make.leading.equalTo(layoutMarginsGuide.snp.leading)
                make.trailing.equalTo(layoutMarginsGuide.snp.trailing)
                make.top.equalTo(layoutMarginsGuide.snp.top)
                make.bottom.equalTo(layoutMarginsGuide.snp.bottom)
            }
        }
    }

    public var contentMargins = Constants.contentMargins {
        didSet {
            contentView.layoutMargins = contentMargins
        }
    }

    public var isContentHidden: Bool {
        get { contentView.alpha == 0.01 }
        set { contentView.alpha = newValue ? 0.01 : 1.0 }
    }

    // MARK: - Internal Properties

    let contentView = UIView()
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 20.0
        return stackView
    }()

    // MARK: - Private Properties

    private var contentViewHeightConstraint: Constraint?
    private lazy var blurView: BlurView = {
        let view = BlurView()
        return view
    }()

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        configure()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) { nil }

    // MARK: - Internal Methods

    func updateContentConstraints(newValue: CGFloat) {
        contentViewHeightConstraint?.update(offset: newValue)
    }
}

// MARK: - Private Methods

extension BaseNavigationBar {
    fileprivate func addSubviews() {
        addSubview(blurView)
        addSubview(stackView)
        stackView.addArrangedSubview(contentView)
    }

    fileprivate func setupConstraints() {
        layoutMargins = innerMargins
        contentView.layoutMargins = contentMargins

        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide.snp.leading)
            make.trailing.equalTo(layoutMarginsGuide.snp.trailing)
            make.top.equalTo(layoutMarginsGuide.snp.top)
            make.bottom.equalTo(layoutMarginsGuide.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            contentViewHeightConstraint = make.height.equalTo(contentSize).constraint
        }
    }

    fileprivate func configure() {
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 32.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
}

// MARK: - Constants

extension BaseNavigationBar {
    enum Constants {
        static let contentSize: CGFloat = 36.0
        static let innerMargins = UIEdgeInsets(top: 12.0, left: .zero, bottom: 20.0, right: .zero)
        static let contentMargins = UIEdgeInsets(top: .zero, left: 10.0, bottom: .zero, right: 10.0)
    }
}
