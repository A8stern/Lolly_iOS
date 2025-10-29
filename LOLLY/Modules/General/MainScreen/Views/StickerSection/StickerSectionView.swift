//
//  StickerSectionView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 2Constants.spacing / 2.10.2025.
//

private import SnapKit
import UIKit

public final class StickerSectionView: UIView, ViewModellable {
    public typealias ViewModel = StickerSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = Fonts.TTTravels.bold.font(size: 24)
        label.textColor = Colors.Text.inverted.color
        return label
    }()

    private lazy var getDrinkButton: Button = {
        let button = Button()
        return button
    }()

    private lazy var cardView: StickerCard = {
        let card = StickerCard()
        return card
    }()

    private lazy var signLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.TTTravels.demiBold.font(size: 74)
        label.textColor = Colors.Text.inverted.color
        label.transform = CGAffineTransform(rotationAngle: CGFloat(10 * CGFloat.pi / 180))
        return label
    }()

    private lazy var backCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Custom.inverted.color.withAlphaComponent(0.2)
        return view
    }()

    private lazy var rightPartStackView: StackView = {
        let stackView = StackView(axis: .vertical)
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var newStickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var backCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Fonts.TTTravels.bold.font(size: 200)
        label.textColor = Colors.Text.inverted.color.withAlphaComponent(0.2)
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfigurable

public extension StickerSectionView {
    func setupLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(Constants.sectionHeight)
        }

        addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.spacing)
            make.left.equalToSuperview()
            make.width.equalTo(cardView.snp.height).multipliedBy(Constants.cardAspectRatio)
        }

        addSubview(signLabel)
        signLabel.snp.makeConstraints { make in
            make.left.equalTo(cardView.snp.right).offset(Constants.spacing / 2)
            make.height.width.equalTo(Constants.signFrameSize)
            make.centerY.equalToSuperview()
        }

        addSubview(backCircleView)
        backCircleView.snp.makeConstraints { make in
            make.left.equalTo(signLabel.snp.right).inset(Constants.spacing)
            make.height.width.equalTo(Constants.largeCircleFrameSize)
            make.centerY.equalToSuperview()
        }

        addSubview(newStickerImageView)
        newStickerImageView.snp.makeConstraints { make in
            make.left.right.equalTo(backCircleView)
            make.top.bottom.equalToSuperview().inset(Constants.spacing / 2)
        }

        addSubview(rightPartStackView)
        rightPartStackView.snp.makeConstraints { make in
            make.left.equalTo(backCircleView.snp.right).offset(Constants.spacing)
            make.top.bottom.right.equalToSuperview().inset(Constants.spacing)
        }

        rightPartStackView.addArrangedSubviews(titleLabel, getDrinkButton)

        addSubview(backCountLabel)
        backCountLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(Constants.spacing)
        }
    }

    func setupUI() {
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 18.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = Colors.accentColor.color

        backCircleView.layer.cornerRadius = Constants.largeCircleFrameSize / 2
        backCircleView.clipsToBounds = true

        getDrinkButton.isHidden = true

        updateUI()
    }

    func setupBehaviour() { }

    func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel else { return }

        titleLabel.text = viewModel.title
        signLabel.text = String(viewModel.sign)
        getDrinkButton.viewModel = viewModel.buttonViewModel
        backCountLabel.text = "\(viewModel.stickersCount)"
        newStickerImageView.image = viewModel.newStickerImage
    }
}

private extension StickerSectionView {
    enum Constants {
        static let sectionHeight: CGFloat = 147.0
        static let cardAspectRatio: CGFloat = 97 / 110
        static let signFrameSize: CGFloat = 43
        static let largeCircleFrameSize: CGFloat = 75
        static let spacing: CGFloat = 18
    }
}
