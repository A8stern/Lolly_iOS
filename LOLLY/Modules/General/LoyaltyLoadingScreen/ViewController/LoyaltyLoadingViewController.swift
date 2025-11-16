//
//  LoyaltyLoadingViewController.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 08.11.2025.
//

internal import UIKit

protocol LoyaltyLoadingView: AnyObject {
    func changeBackgroundColor(to color: UIColor)
    func showText(text: String)
}

final class LoyaltyLoadingViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: LoyaltyLoadingPresenter?

    // MARK: - Private properties

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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Colors.Text.inverted.color
        indicator.hidesWhenStopped = false
        indicator.startAnimating()
        return indicator
    }()

    private lazy var loadingTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.inverted.color
        label.font = Fonts.Styles.title1
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()

        presenter?.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.onViewWillDisappear()
    }
}

extension LoyaltyLoadingViewController {
    fileprivate func addSubviews() {
        view.addSubview(closeButton)
        view.addSubview(transparentCircleImageView)
        view.addSubview(activityIndicator)
        view.addSubview(loadingTextLabel)
    }

    fileprivate func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            make.width.greaterThanOrEqualTo(44)
            make.height.greaterThanOrEqualTo(44)
        }

        transparentCircleImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(126)
            make.centerX.equalTo(view)
            make.height.equalTo(300)
            make.width.equalTo(390)
        }

        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(198)
            make.centerX.equalTo(view)
            make.width.height.equalTo(22)
        }

        loadingTextLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(161)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(115)
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.accentColor.color
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - MainView

extension LoyaltyLoadingViewController: LoyaltyLoadingView {
    func changeBackgroundColor(to color: UIColor) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            view.backgroundColor = color
        }
    }

    func showText(text: String) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loadingTextLabel.text = text
    }
}

// MARK: - NavigationBarDelegate

// MARK: - Constants

extension LoyaltyLoadingViewController {
    fileprivate enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
        static let qrSize: CGFloat = 325.0
    }
}
