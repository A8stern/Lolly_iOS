private import SnapKit

//
//  MainView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

protocol MainView: AnyObject, SnackDisplayable {
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

    private lazy var promoSection: PromoSectionView = {
        let section = PromoSectionView()
        return section
    }()

    private lazy var calendarSection: CalendarSectionView = {
        let section = CalendarSectionView()
        return section
    }()

    private lazy var gameSection: GameSectionView = {
        let section = GameSectionView()
        return section
    }()

    private lazy var contactsSection: ContactsSectionView = {
        let section = ContactsSectionView()
        return section
    }()

    private lazy var profileButton: ProfileButton = {
        let button = ProfileButton()
        return button
    }()

    private lazy var gameSectionTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onGameSectionTap))
        return gesture
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

extension MainViewController {
    fileprivate func addSubviews() {
        for item in [blurView, scrollView, navBar] {
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
            promoSection,
            gameSection,
            calendarSection,
            contactsSection
        )
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color

        navigationController?.isNavigationBarHidden = true
        navBar.delegate = self
        navBar.addRightButton(profileButton)
        navBar.contentSize = 24.0

        gameSection.addGestureRecognizer(gameSectionTapGesture)
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

    @objc
    fileprivate func onGameSectionTap() {
        presenter?.onGameSectionTap()
    }
}

// MARK: - MainView

extension MainViewController: MainView {
    func displayInitialData(viewModel: MainModels.InitialData.ViewModel) {
        profileButton.viewModel = viewModel.profileButtonViewModel
        stickerSection.viewModel = viewModel.stickerSectionViewModel
        calendarSection.viewModel = viewModel.calendarSectionViewModel
        gameSection.viewModel = viewModel.gameSectionViewModel
        contactsSection.viewModel = viewModel.contactsSectionViewModel
        promoSection.viewModel = viewModel.promoSectionViewModel
    }
}

// MARK: - NavigationBarDelegate

extension MainViewController: NavigationBarDelegate { }

// MARK: - Constants

extension MainViewController {
    fileprivate enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
    }
}
