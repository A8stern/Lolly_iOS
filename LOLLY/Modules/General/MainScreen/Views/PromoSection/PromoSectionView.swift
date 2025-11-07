//
//  PromoSectionView.swift
//  LOLLY
//
//  Created by Nikita on 03.11.2025.
//

private import SnapKit
import UIKit

public final class PromoSectionView: UIView, ViewModellable {
    public typealias ViewModel = PromoSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var promoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.TTTravels.demiBold.font(size: 18)
        label.textColor = Colors.Text.primary.color
        return label
    }()

    // MARK: - Perforation Circles

    private let leftCircleView = UIView()
    private let rightCircleView = UIView()

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 18.0
        static let perforationRadius: CGFloat = 7.0
        static let horizontalInset: CGFloat = 20.0
        static let verticalInset: CGFloat = 24.0
        static let perforationDiameter: CGFloat = perforationRadius * 2
    }

    // MARK: - Lifecycle

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

// MARK: - Private methods

extension PromoSectionView {
    fileprivate func setupLayout() {
        addSubview(leftCircleView)
        addSubview(rightCircleView)
        addSubview(promoLabel)

        leftCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
            make.size.equalTo(Constants.perforationDiameter)
        }
        rightCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
            make.size.equalTo(Constants.perforationDiameter)
        }

        leftCircleView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
            make.size.equalTo(Constants.perforationDiameter)
        }
        rightCircleView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
            make.size.equalTo(Constants.perforationDiameter)
        }

        leftCircleView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
            make.size.equalTo(Constants.perforationDiameter)
        }
        rightCircleView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.right)
            make.size.equalTo(Constants.perforationDiameter)
        }

        promoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.bottom.equalToSuperview().inset(Constants.verticalInset)
        }
    }

    fileprivate func setupUI() {
        clipsToBounds = true
        backgroundColor = Colors.Controls.inactive.color
        layer.cornerRadius = Constants.cornerRadius

        for circleView in [leftCircleView, rightCircleView] {
            circleView.backgroundColor = Colors.Custom.inverted.color
            circleView.layer.cornerRadius = Constants.perforationRadius
            circleView.layer.masksToBounds = true
        }

        updateUI()
    }

    fileprivate func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel else { return }

        promoLabel.text = viewModel.text
    }
}
