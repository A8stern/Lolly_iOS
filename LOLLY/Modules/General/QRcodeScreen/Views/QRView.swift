//
//  QRSectionView.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

private import SnapKit
import UIKit

public final class QRView: UIView, ViewModellable {
    public typealias ViewModel = QRViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.isHiddenWhenSkeletonIsActive = true
        return imageView
    }()

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 24.0
        static let inset: CGFloat = 24.0
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

extension QRView {
    fileprivate func setupLayout() {
        addSubview(qrImageView)
        qrImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.inset)
            make.height.equalTo(qrImageView.snp.width)
        }
    }

    fileprivate func setupUI() {
        backgroundColor = Colors.Constants.white.color
        skeletonCornerRadius = Float(Constants.cornerRadius)
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        clipsToBounds = true

        updateUI()
    }

    fileprivate func updateUI() {
        isHidden = viewModel == nil
        guard let viewModel else { return }

        if viewModel.isSkeletonable {
            displaySkeleton()
        } else {
            dismissSkeleton()
        }

        qrImageView.image = viewModel.qrImage
    }
}

// MARK: - SkeletonCallable

extension QRView: SkeletonCallable {
    public func prepareForDisplaySkeleton() { }

    public func prepareForDismissSkeleton() { }
}
