//
//  PushNotifyViewController.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

private import SnapKit
import UIKit

protocol PushNotifyView: AnyObject, SnackDisplayable {
    func displayInitialData(viewModel: PushNotifyModels.InitialData.ViewModel)
}

final class PushNotifyViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: PushNotifyPresenter?

    // MARK: - Private properties

    // MARK: - Views

    private lazy var navBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.isHiddenRightButton = true
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
        let stackView = StackView(axis: .vertical, space: 3)
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var pushNotifySection: PushNotifySectionView = {
        let section = PushNotifySectionView()
        return section
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewInsetIfNeeded()
    }
}

// MARK: - Private methods

extension PushNotifyViewController {
    fileprivate func addSubviews() {
        for item in [scrollView, navBar] {
            view.addSubview(item)
        }
        scrollView.addSubview(contentView)
        contentView.addSubview(sectionsStackView)
    }

    fileprivate func setupConstraints() {
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

        sectionsStackView.addArrangedSubviews(
            pushNotifySection
        )
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color

        navigationController?.isNavigationBarHidden = true
        navBar.delegate = self
        navBar.contentSize = 24.0
    }

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
}

// MARK: - AdminAdminView

extension PushNotifyViewController: PushNotifyView {
    func displayInitialData(viewModel: PushNotifyModels.InitialData.ViewModel) {
        pushNotifySection.viewModel = viewModel.pushNotifyViewModel
        navBar.title = viewModel.title
    }
}

// MARK: - NavigationBarDelegate

extension PushNotifyViewController: NavigationBarDelegate {
    func didReceiveBackAction(_: NavigationBar) {
        presenter?.closePush()
    }
}

// MARK: - Constants

extension PushNotifyViewController {
    fileprivate enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .init(top: 0, left: 36, bottom: 0, right: 36)
    }
}
