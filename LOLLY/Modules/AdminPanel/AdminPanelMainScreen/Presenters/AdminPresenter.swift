//
//  AdminPresenter.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

protocol AdminPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// События показа экрана
    func onViewWillAppear()

    /// Триггер загрузки данных
    func onViewDidAppear()

    /// Получить роль пользователя
    func getUserRole(phone: String) -> UserRoleStatus
}

final class AdminViewPresenter {
    // MARK: - Private Properties

    private unowned let view: AdminView
    private let coordinator: AdminCoordinator
    private let authorizationService: AuthorizationServiceInterface

    // MARK: - Initialization

    init(
        view: AdminView,
        coordinator: AdminCoordinator,
        authorizationService: AuthorizationServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.authorizationService = authorizationService
    }
}

extension AdminViewPresenter: AdminPresenter {
    func onViewDidLoad() {
        let response = AdminModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func getUserRole(phone: String) -> UserRoleStatus {
        let isMock = true
        if isMock {
            return .admin
        }

        var role = nil as UserRoleStatus?
        Task {
            do {
                let status: UserRoleStatus = try await authorizationService.fetchUserStatus(phone: phone)
                role = status
            } catch {
                print(error)
            }
        }
        guard let role else { return UserRoleStatus.unknown }
        return role
    }
}

// MARK: - Private Methods

extension AdminViewPresenter {
    fileprivate func responseInitialData(response _: AdminModels.InitialData.Response) {
        let viewModel = AdminModels.InitialData.ViewModel(
            title: L10n.Main.title,
            functionalSectionViewModel: makeFunctionalSectionViewModel()
        )

        view.displayInitialData(viewModel: viewModel)
    }

    fileprivate func getSectionsByRole() -> [[SectionButtonViewModel]] {
        let userRole = UserRoleStatus.admin // let userRole = getUserRole(phone: "")

        var contentSectionViewModels: [SectionButtonViewModel] = []
        var functionalSectionViewModels: [SectionButtonViewModel] = []

        switch userRole {
            case .unknown, .user, .notRegistered:
                contentSectionViewModels = []
                functionalSectionViewModels = []

            case .admin:
                contentSectionViewModels = makeContentSectionViewModelsForAdministrator()
                functionalSectionViewModels = makeFunctionalSectionViewModelsForAdministrator()

            case .barista:
                functionalSectionViewModels = [
                    SectionButtonViewModel(
                        iconAsset: Assets.Icons29.Adminpanel.qr,
                        text: L10n.AdminPanel.Section.qr,
                        tapHandler: nil
                    )
                ]
        }
        return [contentSectionViewModels, functionalSectionViewModels]
    }

    fileprivate func makeContentSectionViewModelsForAdministrator() -> [SectionButtonViewModel] {
        [
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.loyaltycard,
                text: L10n.AdminPanel.Section.loyaltyCard,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.popup,
                text: L10n.AdminPanel.Section.popUp,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.textslider,
                text: L10n.AdminPanel.Section.textSlider,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.aigame,
                text: L10n.AdminPanel.Section.ai,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.events,
                text: L10n.AdminPanel.Section.events,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.link,
                text: L10n.AdminPanel.Section.links,
                tapHandler: nil
            )
        ]
    }

    fileprivate func makeFunctionalSectionViewModelsForAdministrator() -> [SectionButtonViewModel] {
        [
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.qr,
                text: L10n.AdminPanel.Section.qr,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.push,
                text: L10n.AdminPanel.Section.push,
                tapHandler: { [weak self] in
                    guard let self else { return }
                    coordinator.showPush()
                }
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.user,
                text: L10n.AdminPanel.Section.users,
                tapHandler: nil
            ),
            SectionButtonViewModel(
                iconAsset: Assets.Icons29.Adminpanel.administrator,
                text: L10n.AdminPanel.Section.administrators,
                tapHandler: nil
            )
        ]
    }

    fileprivate func makeFunctionalSectionViewModel() -> FuncSectionViewModel? {
        let sections = getSectionsByRole()

        return FuncSectionViewModel(
            fTitle: L10n.AdminPanel.Title.functions,
            sTitle: L10n.AdminPanel.Title.sections,
            fSections: sections[1],
            sSections: sections[0]
        )
    }
}
