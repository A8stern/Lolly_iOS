private import SnapKit
//
//  MainView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

protocol MainView: AnyObject {
//    func displaySomething()
//    func displayBanners()
//    func showSnackbarError(_ error: String?)
}

final class MainViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: MainPresenter?

    // MARK: - Private properties

    // MARK: - Views

    private lazy var navBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.isHiddenRightButton = true
        navigationBar.isBackButtonHidden = true
        // TODO: Вставить имя приложения через презентер
        navigationBar.title = "Вставить имя"
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

private extension MainViewController {
    func addSubviews() {
        [scrollView, navBar].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        contentView.addSubview(sectionsStackView)
    }

    func setupConstraints() {
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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

    func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color
        navigationController?.isNavigationBarHidden = true
        navBar.delegate = self
    }
}

// MARK: - MainView

extension MainViewController: MainView { }

// MARK: - NavigationBarDelegate

extension MainViewController: NavigationBarDelegate { }

// MARK: - Constants

private extension MainViewController {
    enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
    }
}
