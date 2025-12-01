//
//  PhotoPermissionViewController.swift
//  Brewsell
//
//  Created by Kovalev Gleb on 29.11.2025.
//

private import SnapKit
internal import UIKit

protocol PhotoPermissionView: AnyObject {}

final class PhotoPermissionViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: PhotoPermissionPresenter?

    // MARK: - Views

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Text.inverted.color
        button.setImage(Assets.Controls.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addActionHandler({ [weak self] in
            guard let self else { return }
            presenter?.onCloseTap()
        }, for: .touchUpInside)
        return button
    }()

    private lazy var transparentCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Loading.transparentCircle.image
        return imageView
    }()

    private lazy var phoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Permission.cameraPermission.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var permissionTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.inverted.color
        label.font = Fonts.Styles.title1
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = L10n.Permission.Camera.title
        return label
    }()

    private lazy var smallTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.inverted.color
        label.font = Fonts.Styles.body
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = L10n.Permission.Camera.body
        return label
    }()

    private lazy var goToSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.Constants.yellow.color
        button.setTitleColor(Colors.Text.primary.color, for: .normal)
        button.titleLabel?.font = Fonts.Styles.body
        button.layer.cornerRadius = 17 // визуально корректно при высоте 34
        button.clipsToBounds = true
        button.setTitle(L10n.Permission.Camera.buttonLabel, for: .normal)
        button.addTarget(self, action: #selector(didTapGoToSettings), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()

        presenter?.onViewDidLoad()
    }

    // MARK: - Actions

    @objc
    private func didTapGoToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension PhotoPermissionViewController {
    fileprivate func addSubviews() {
        view.addSubview(closeButton)
        view.addSubview(transparentCircleImageView)
        view.addSubview(phoneImageView)
        view.addSubview(permissionTextLabel)
        view.addSubview(smallTextLabel)
        view.addSubview(goToSettingsButton)
    }

    fileprivate func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            make.width.greaterThanOrEqualTo(24)
            make.height.greaterThanOrEqualTo(24)
        }

        transparentCircleImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(126)
            make.centerX.equalTo(view)
            make.height.equalTo(300)
            make.width.equalTo(390)
        }

        phoneImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(95)
            make.centerX.equalTo(view)
            make.height.lessThanOrEqualTo(261)
            make.width.lessThanOrEqualTo(154.46)
        }

        permissionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneImageView.snp.bottom).offset(46)
            make.leading.greaterThanOrEqualTo(view.layoutMarginsGuide.snp.leading)
            make.trailing.lessThanOrEqualTo(view.layoutMarginsGuide.snp.trailing)
            make.leading.equalTo(view).inset(24)
            make.trailing.equalTo(view).inset(24)
            make.centerX.equalTo(view)
        }

        smallTextLabel.snp.makeConstraints { make in
            make.top.equalTo(permissionTextLabel.snp.bottom).offset(16)
            make.leading.equalTo(view).inset(24)
            make.trailing.equalTo(view).inset(24)
            make.centerX.equalTo(view)
        }

        goToSettingsButton.snp.makeConstraints { make in
            make.top.equalTo(smallTextLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view).inset(130)
            make.height.equalTo(34)
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.accentColor.color
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - MainView

extension PhotoPermissionViewController: PhotoPermissionView {}

// MARK: - Constants

extension PhotoPermissionViewController {
    fileprivate enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
        static let qrSize: CGFloat = 325.0
    }
}
