//
//  GameSectionView.swift
//  LOLLY
//
//  Created by Егор on 29.10.2025.
//

private import SnapKit
import UIKit

public final class GameSectionView: UIView, ViewModellable {
    public typealias ViewModel = GameSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = Fonts.TTTravels.demiBold.font(size: 18)
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var waveformImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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

extension GameSectionView {
    public func setupLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(Constants.sectionHeight)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
            make.top.equalToSuperview().inset(Constants.padding)
        }

        addSubview(waveformImageView)
        waveformImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(Constants.padding)
        }
    }

    public func setupUI() {
        layer.cornerRadius = 18.0
        clipsToBounds = true
        backgroundColor = Colors.Constants.yellow.color

        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel else { return }

        titleLabel.text = viewModel.title
        waveformImageView.image = viewModel.waveformImage
    }
}

extension GameSectionView {
    fileprivate enum Constants {
        static let sectionHeight: CGFloat = 151.0
        static let padding: CGFloat = 16.0
        static let textToWaveformSpacing: CGFloat = 12.0
        static let waveformHeight: CGFloat = 32.0
    }
}
