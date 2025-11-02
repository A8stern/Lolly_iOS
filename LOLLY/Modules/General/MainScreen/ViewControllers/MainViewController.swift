private import SnapKit
//
//  MainView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

protocol MainView: AnyObject {
    func displayInitialData(viewModel: MainModels.InitialData.ViewModel)
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

    private lazy var blurView: BlurView = {
        let view = BlurView()
        return view
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

    private lazy var stickerSection: StickerSectionView = {
        let section = StickerSectionView()
        return section
    }()

    private lazy var calendarSection: CalendarSectionView = {
        let section = CalendarSectionView()
        return section
    }()

    private lazy var contactsSection: ContactsSectionView = {
        let section = ContactsSectionView()
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

private extension MainViewController {
    func addSubviews() {
        [blurView, scrollView, navBar].forEach {
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

        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            stickerSection,
            calendarSection,
            contactsSection
        )
    }

    func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color
        navigationController?.isNavigationBarHidden = true
        navBar.delegate = self
    }

    func adjustScrollViewInsetIfNeeded() {
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

// MARK: - MainView

extension MainViewController: MainView {
    func displayInitialData(viewModel: MainModels.InitialData.ViewModel) {
        stickerSection.viewModel = viewModel.stickerSectionViewModel
        calendarSection.viewModel = viewModel.calendarSectionViewModel
        contactsSection.viewModel = viewModel.contactsSectionViewModel
    }
}

// MARK: - NavigationBarDelegate

extension MainViewController: NavigationBarDelegate { }

// MARK: - Constants

private extension MainViewController {
    enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
    }
}
