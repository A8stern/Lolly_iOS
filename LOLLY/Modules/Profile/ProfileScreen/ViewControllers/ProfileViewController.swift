//
//  ProfileViewController.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 08.11.2025.
//

private import SnapKit
import UIKit

protocol ProfileView: AnyObject, SnackDisplayable {
    func displayInitialData(viewModel: ProfileModels.InitialData.ViewModel)
}

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenter?

    // MARK: - Private views

    private lazy var navBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.isBackButtonHidden = false
        navigationBar.isEnabledBackButton = true
        return navigationBar
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var sectionsStackView: StackView = {
        let stackView = StackView(axis: .vertical, space: 8)
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.Custom.inverted.color

        addSubviews()
        setupConstraints()
        setupBehavior()

        presenter?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.onViewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter?.onViewDidDisappear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewInsetIfNeeded()
    }

    // MARK: - Private methods

    fileprivate func adjustScrollViewInsetIfNeeded() {
        let topInset: CGFloat = navBar.bounds.height - navBar.safeAreaInsets.top
        let bottomInset: CGFloat = .zero

        let currentTopInset = scrollView.contentInset.top
        let currentBottomInset = scrollView.contentInset.bottom

        if currentTopInset != topInset {
            scrollView.contentInset.top = topInset
        }
        if currentBottomInset != bottomInset {
            scrollView.contentInset.bottom = bottomInset
        }
    }

    private func addSubviews() {
        for item in [scrollView, navBar] {
            view.addSubview(item)
        }
        scrollView.addSubview(contentView)
        contentView.addSubview(sectionsStackView)
    }

    private func setupConstraints() {
        extendedLayoutIncludesOpaqueBars = true
        view.layoutMargins = Constants.innerMargins
        contentView.layoutMargins = Constants.contentMargins

        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }

        sectionsStackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide.snp.leading)
            make.trailing.equalTo(contentView.layoutMarginsGuide.snp.trailing)
            make.top.equalTo(contentView.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom)
        }
    }

    private func setupBehavior() {
        navigationController?.isNavigationBarHidden = true
        navBar.delegate = self
    }
}

// MARK: - ProfileView

extension ProfileViewController: ProfileView {
    func displayInitialData(viewModel: ProfileModels.InitialData.ViewModel) {
        navBar.title = viewModel.title
    }
}

// MARK: - NavigationBarDelegate

extension ProfileViewController: NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) {
        presenter?.leave()
    }
}

// MARK: - Constants

extension ProfileViewController {
    fileprivate enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
    }
}
