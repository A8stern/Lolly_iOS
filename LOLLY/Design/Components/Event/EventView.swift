//
//  EventView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

private import SnapKit
import UIKit

public final class EventView: UIView, ViewModellable {
    public typealias ViewModel = EventViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = Fonts.TTTravels.demiBold.font(size: 14)
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = Fonts.TTTravels.demiBold.font(size: 14)
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.accentColor.color
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

extension EventView {
    public func setupLayout() {
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(47)
        }

        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(8)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.left.equalTo(lineView.snp.right).offset(8)
        }

        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(8)
            make.left.equalTo(lineView.snp.right).offset(8)
        }
    }

    public func setupUI() {
        lineView.layer.cornerRadius = Constants.lineWidth / 2
        lineView.layer.masksToBounds = true

        updateUI()
    }

    public func setupBehaviour() {
        addTapActionHandler { [weak self] in
            guard let self else { return }
            guard let viewModel else { return }

            viewModel.onTap?()
        }
    }

    public func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

extension EventView {
    fileprivate enum Constants {
        static let circleDiameter: CGFloat = 14
        static let lineWidth: CGFloat = 8
    }
}
