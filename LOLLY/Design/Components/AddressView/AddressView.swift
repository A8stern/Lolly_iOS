//
//  AddressView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 02.11.2025.
//

private import SnapKit
import UIKit

public final class AddressView: UIView, ViewModellable {
    public typealias ViewModel = AddressViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = Fonts.Styles.body
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = Fonts.Styles.body
        label.textColor = Colors.Text.secondary.color
        return label
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

extension AddressView {
    public func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(Constants.spacing)
        }
    }

    public func setupUI() {
        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }

        titleLabel.text = viewModel.address
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description == nil
    }
}

extension AddressView {
    fileprivate enum Constants {
        static let spacing: CGFloat = 4
    }
}
