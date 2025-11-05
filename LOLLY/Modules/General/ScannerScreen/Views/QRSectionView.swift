//
//  QRSectionView.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

private import SnapKit
import UIKit

public final class QRSectionView: UIView, ViewModellable {
    public typealias ViewModel = QRSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var promoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.TTTravels.medium.font(size: 14)
        label.textColor = Colors.Text.inverted.color
        return label
    }()

    private lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var qrBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.qrBackgroundCornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [qrBackgroundView, promoLabel])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        return stack
    }()

    // MARK: - Shape

    private let maskLayer = CAShapeLayer()

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 18.0
        static let perforationRadius: CGFloat = 7.0
        static let horizontalInset: CGFloat = 20.0
        static let verticalInset: CGFloat = 0.0
        static let perforationInsetFromEdge: CGFloat = 0.0
        static let qrSize: CGFloat = 325.0
        static let qrBackgroundExtra: CGFloat = 24.0
        static let qrBackgroundCornerRadius: CGFloat = 24.0
    }

    // MARK: - Lifecycle

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension QRSectionView {
    func setupLayout() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(Constants.horizontalInset)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.horizontalInset)
        }

        qrBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(Constants.qrSize + Constants.qrBackgroundExtra)
            make.height.equalTo(Constants.qrSize + Constants.qrBackgroundExtra)
        }

        qrBackgroundView.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Constants.qrSize)
        }

        promoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

    func setupUI() {
        clipsToBounds = true
        backgroundColor = Colors.accentColor.color
        updateUI()
    }

    func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel
        else {
            qrImageView.image = nil
            promoLabel.text = nil
            return
        }

        promoLabel.text = viewModel.text
        qrImageView.image = viewModel.qrImage
    }
}
