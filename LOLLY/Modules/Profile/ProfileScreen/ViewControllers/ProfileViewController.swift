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
    func displayProfileInfo(viewModel: ProfileModels.ProfileInfo.ViewModel)
    func setLoading(_ isLoading: Bool)
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
        let stackView = StackView(axis: .vertical, space: 24)
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var nameInfoView = ProfileInfoRowView(subtitle: "Твоё имя")

    private lazy var phoneInfoView = ProfileInfoRowView(subtitle: "Номер телефона")

    private lazy var discountsHeaderLabel = ProfileSectionHeaderView(title: "скидки и новости")

    private lazy var notificationsRow: ProfileToggleRowView = {
        let view = ProfileToggleRowView(title: "Push уведомления")
        view.onToggle = { [weak self] isOn in
            self?.presenter?.onPushToggleChanged(isOn: isOn)
        }
        return view
    }()

    private lazy var settingsHeaderLabel = ProfileSectionHeaderView(title: "настройки приложения")

    private lazy var themeSelectorView: ThemeSelectorView = {
        let view = ThemeSelectorView()
        view.onThemeChanged = { [weak self] theme in
            ThemeManager.shared.currentTheme = theme
        }
        return view
    }()

    private lazy var deleteAccountRow: ProfileNavigationRowView = {
        let view = ProfileNavigationRowView(title: "Запрос на удаление аккаунта")
        view.onTap = { [weak self] in
            self?.presenter?.onDeleteAccountTap()
        }
        return view
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(Colors.Status.error.color, for: .normal)
        button.titleLabel?.font = Fonts.Styles.custom(weight: .bold, size: 18)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
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
        contentView.addSubview(logoutButton)

        sectionsStackView.addArrangedSubviews(
            nameInfoView,
            phoneInfoView,
            ProfileSeparatorView(),
            discountsHeaderLabel,
            notificationsRow,
            settingsHeaderLabel,
            themeSelectorView,
            deleteAccountRow
        )
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
        }

        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sectionsStackView.snp.bottom).offset(Constants.logoutButtonTopOffset)
            make.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom).inset(Constants.logoutButtonBottomInset)
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

    func displayProfileInfo(viewModel: ProfileModels.ProfileInfo.ViewModel) {
        nameInfoView.value = viewModel.name
        phoneInfoView.value = viewModel.phone
    }

    func setLoading(_ isLoading: Bool) {
        // TODO: Реализовать индикатор загрузки при необходимости
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
        static let contentMargins: UIEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        static let logoutButtonTopOffset: CGFloat = 32
        static let logoutButtonBottomInset: CGFloat = 32
    }
}

// MARK: - Actions

private extension ProfileViewController {
    @objc
    func logoutButtonTapped() {
        presenter?.onLogoutTap()
    }
}

// MARK: - Supporting Views

private final class ProfileInfoRowView: UIView {
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let separatorView = ProfileSeparatorView()

    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }

    init(subtitle: String) {
        super.init(frame: .zero)
        setup(subtitle: subtitle)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(subtitle: String) {
        valueLabel.font = Fonts.Styles.custom(weight: .medium, size: 20)
        valueLabel.textColor = Colors.Text.primary.color
        valueLabel.numberOfLines = 1
        valueLabel.text = "—"

        subtitleLabel.font = Fonts.Styles.body
        subtitleLabel.textColor = Colors.Text.secondary.color
        subtitleLabel.text = subtitle

        let stack = StackView(axis: .vertical, space: 4)
        stack.addArrangedSubviews(valueLabel, subtitleLabel)

        addSubview(stack)
        addSubview(separatorView)

        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }
}

private final class ProfileSectionHeaderView: UIView {
    init(title: String) {
        super.init(frame: .zero)
        let label = UILabel()
        label.text = title.uppercased()
        label.font = Fonts.Styles.caption
        label.textColor = Colors.Text.secondary.color
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class ProfileToggleRowView: UIView {
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    private let separator = ProfileSeparatorView()

    var onToggle: ((Bool) -> Void)?

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = Fonts.Styles.custom(weight: .bold, size: 18)
        titleLabel.textColor = Colors.Text.primary.color

        toggle.onTintColor = Colors.Controls.primary.color
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)

        addSubview(titleLabel)
        addSubview(toggle)
        addSubview(separator)

        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.lessThanOrEqualTo(toggle.snp.leading).offset(-16)
        }

        toggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }

        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func toggleChanged() {
        onToggle?(toggle.isOn)
    }
}

private final class ProfileNavigationRowView: UIView {
    var onTap: (() -> Void)?
    private let separator = ProfileSeparatorView()

    init(title: String) {
        super.init(frame: .zero)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Fonts.Styles.custom(weight: .bold, size: 18)
        titleLabel.textColor = Colors.Text.primary.color

        let arrowImage = UIImageView(image: Assets.Controls.nextArrow.image.withRenderingMode(.alwaysTemplate))
        arrowImage.tintColor = Colors.Text.secondary.color

        addSubview(titleLabel)
        addSubview(arrowImage)
        addSubview(separator)

        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.lessThanOrEqualTo(arrowImage.snp.leading).offset(-8)
        }

        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }

        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func handleTap() {
        onTap?()
    }
}

private final class ProfileSeparatorView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.Constants.grey.color.withAlphaComponent(0.2)
        snp.makeConstraints { make in
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
