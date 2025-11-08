//
//  CalendarCell.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

private import SnapKit
import UIKit

public final class CalendarCell: UICollectionViewCell, ViewModellable {
    public var viewModel: CalendarCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = Fonts.Styles.custom(weight: .bold, size: 50)
        label.textColor = Colors.Text.inverted.color
        return label
    }()

    private lazy var circleView: UIView = {
        let view = UIView(
            frame: CGRect(
                x: .zero,
                y: .zero,
                width: Constants.circleDiameter,
                height: Constants.circleDiameter
            )
        )
        view.layer.cornerRadius = view.frame.size.width / 2
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.Constants.yellow.color
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
        setupBehaviour()
    }

    public convenience init(viewModel: CalendarCellViewModel?) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateUI()
    }
}

// MARK: - ViewConfigurable

extension CalendarCell {
    public func setupLayout() {
        snp.makeConstraints { make in
            make.height.width.equalTo(CalendarCell.fixedSize)
        }
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.circleDiameter)
            make.top.right.equalToSuperview().inset(10)
        }
    }

    public func setupUI() {
        backgroundColor = Colors.accentColor.color
        layer.cornerRadius = 18
        layer.masksToBounds = true

        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }

        dateLabel.text = "\(viewModel.date)"
        circleView.isHidden = viewModel.type != .current

        switch viewModel.type {
            case .past:
                backgroundColor = Colors.Controls.disabled.color.withAlphaComponent(0.5)
                dateLabel.textColor = Colors.Controls.secondary.color

            case .current:
                backgroundColor = Colors.accentColor.color
                dateLabel.textColor = Colors.Text.inverted.color

            case .future:
                backgroundColor = Colors.Controls.disabled.color.withAlphaComponent(0.8)
                dateLabel.textColor = Colors.Text.secondary.color.withAlphaComponent(0.5)
        }
    }
}

extension CalendarCell {
    public static let fixedSize: CGFloat = 102

    private enum Constants {
        static let circleDiameter: CGFloat = 14
    }
}
