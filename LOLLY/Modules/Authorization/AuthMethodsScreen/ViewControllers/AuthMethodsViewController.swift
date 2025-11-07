//
//  AuthMethodsViewController.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

private import SnapKit
import UIKit

protocol AuthMethodsView: AnyObject {
    func displayInitialData(viewModel: AuthMethodsModels.InitialData.ViewModel)
}

final class AuthMethodsViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: AuthMethodsPresenter?

    // MARK: - Private properties

    // MARK: - Views

    private lazy var backgroundVideoView: VideoView = {
        let videoView = VideoView()
        return videoView
    }()

    private lazy var bottomShadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Authorization.bottomShadow.image
        return imageView
    }()

    private lazy var contentStackView: StackView = {
        let stackView = StackView(axis: .vertical, space: 20)
        return stackView
    }()

    private lazy var contentContainer: ViewContainer<StackView> = ViewContainer(
        block: {
            contentStackView
        },
        insets: Constants.contentContainerInsets
    )

    private lazy var conditionsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.font = Fonts.TTTravels.regular.font(size: 12)
        label.textColor = Colors.Constants.grey.color
        return label
    }()

    private lazy var appleSignInButton: Button = {
        let button = Button()
        return button
    }()

    private lazy var phoneSignInButton: Button = {
        let button = Button()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
}

// MARK: - Private methods

extension AuthMethodsViewController {
    fileprivate func addSubviews() {
        view.addSubview(backgroundVideoView)
        view.addSubview(bottomShadowImageView)
        view.addSubview(contentContainer)
    }

    fileprivate func setupConstraints() {
        contentContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view).inset(24)
        }

        contentStackView.addArrangedSubviews(
            appleSignInButton,
            phoneSignInButton
        )

        contentStackView.setCustomSpace(12, after: appleSignInButton)
        contentStackView.addArrangedSubview(conditionsLabel)

        backgroundVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bottomShadowImageView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
    }

    fileprivate func setupViews() {
        for subview in view.subviews {
            subview.overrideUserInterfaceStyle = .dark
        }

        view.backgroundColor = Colors.Constants.white.color
        contentContainer.backgroundColor = .clear
    }
}

// MARK: - MainView

extension AuthMethodsViewController: AuthMethodsView {
    func displayInitialData(viewModel: AuthMethodsModels.InitialData.ViewModel) {
        backgroundVideoView.viewModel = viewModel.backgroundVideoViewModel
        phoneSignInButton.viewModel = viewModel.phoneSignInButtonViewModel
        appleSignInButton.viewModel = viewModel.appleSignInButtonViewModel
        conditionsLabel.text = viewModel.conditions
    }
}

extension AuthMethodsViewController {
    fileprivate enum Constants {
        static let contentContainerInsets = UIEdgeInsets(top: 20, left: 32, bottom: 20, right: 32)
    }
}
