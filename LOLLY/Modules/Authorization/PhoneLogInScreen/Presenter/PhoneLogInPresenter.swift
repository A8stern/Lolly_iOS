//
//  PhoneLogInPresenter.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

private import PhoneNumberKit
internal import UIKit

protocol PhoneLogInPresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    func onViewWillAppear()

    func onViewDidDisappear()

    func phoneFieldChanged(_ value: String)

    func phoneFieldEndEditing()

    func nameFieldChanged(_ value: String)

    func nameFieldEndEditing()
}

final class PhoneLogInViewPresenter {
    // MARK: - Private Properties

    private unowned let view: PhoneLogInView
    private let coordinator: AuthCoordinator
    private let authorizationService: AuthorizationServiceInterface
    private let phoneNumberUtility = PhoneNumberUtility()

    private var userRoleStatus: UserRoleStatus?
    private var phone: Phone?
    private var isPhoneValid = false
    private var name: String = ""
    private var nameCaption: String?
    private var isNameValid = false
    private var isLoading = false
    private var isCheckboxSelected = false

    // MARK: - Initialization

    init(
        view: PhoneLogInView,
        coordinator: AuthCoordinator,
        authorizationService: AuthorizationServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.authorizationService = authorizationService
    }
}

// MARK: - AuthMethodsPresenter

extension PhoneLogInViewPresenter: PhoneLogInPresenter {
    func onViewDidLoad() {
        let response = PhoneLogInModels.InitialData.Response()
        responseInitialData(response: response)
    }

    func onViewWillAppear() {
        updateContinueButton()
    }

    func onViewDidDisappear() {
        userRoleStatus = nil
    }

    func phoneFieldChanged(_ value: String) {
        /// Свалидированные числа от юзера. Может быть не номер. Например +79139999999
        let resultPhone = value.filter { isValidSymbols(phone: String($0)) == true }
        isPhoneValid = isValid(phone: resultPhone)
        if !isPhoneValid {
            phone = Phone(raw: resultPhone)
        }

        updatePhoneField()
        updateContinueButton()
    }

    func phoneFieldEndEditing() {
        updatePhoneField()
        updateContinueButton()
    }

    func nameFieldChanged(_ value: String) {
        let resultName = value.filter { isValidSymbols(name: String($0)) == true }
        isNameValid = isValid(name: resultName)
        name = resultName

        updateNameFieldCaption()
        updateNameField()
        updateContinueButton()
    }

    func nameFieldEndEditing() {
        updateNameFieldCaption()
        updateNameField()
    }
}

// MARK: - Private Methods

private extension PhoneLogInViewPresenter {
    func responseInitialData(response: PhoneLogInModels.InitialData.Response) {
        let viewModel = PhoneLogInModels.InitialData.ViewModel(
            continueButtonViewModel: ButtonViewModel(
                title: L10n.PhoneLogIn.Buttons.continue,
                type: .primary(nil),
                size: .large,
                tapHandler: { [weak self] in
                    guard let self else { return }
                    guard userRoleStatus == nil else {
                        registerNewAccount()
                        return
                    }
                    guard let phone else { return }
                    fetchUserStatus(phone: phone)
                }
            ),
            isContinueButtonEnabled: false,
            isNameTextFieldHidden: true,
            isPrivacyCheckBoxHidden: true,
            onPrivacyCheckboxTap: { [weak self] in
                guard let self else { return }
                isCheckboxSelected.toggle()
                updateContinueButton()
            }
        )

        view.displayInitialData(viewModel: viewModel)
    }

    func isValid(name string: String) -> Bool {
        guard string.count >= 2 else { return false }

        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", RegExConstants.namePattern)

        return predicate.evaluate(with: string)
    }

    func isValid(phone string: String) -> Bool {
        let parsedPhone: PhoneNumber
        do {
            /// Распарсенный номер +79139999999
            parsedPhone = try phoneNumberUtility.parse(string)
        } catch {
            print("Invalid phone number (parse failed): \(string). Error: \(error)")
            return false
        }
        let formattedPhone: String = phoneNumberUtility.format(parsedPhone, toType: .e164)
        phone = Phone(raw: formattedPhone)
        return true
    }

    func isValidSymbols(name string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", RegExConstants.validSymbols)

        return predicate.evaluate(with: string)
    }

    func isValidSymbols(phone string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", RegExConstants.validPhoneSymbols)

        return predicate.evaluate(with: string)
    }

    func updateNameFieldCaption() {
        nameCaption = {
            guard isNameValid == false else {
                return nil
            }
            // caption об обязательном поле показываем после выхода из режима редактирования
            return name.isEmpty ? nil : L10n.PhoneLogIn.Name.validationError
        }()
    }

    func updateNameField() {
        let viewModel = PhoneLogInModels.NameField.ViewModel(
            name: name,
            state: {
                guard isLoading == false else {
                    return .disabled
                }
                // если задан caption у nameField, значит состояние невалидное
                guard self.nameCaption == nil else {
                    return .invalid
                }
                return self.name.isEmpty ? .empty : .correct
            }(),
            caption: nameCaption ?? ""
        )
        view.updateNameField(viewModel: viewModel)
    }

    func updatePhoneField() {
        guard let phone else { return }

        let viewModel = PhoneLogInModels.PhoneField.ViewModel(
            phone: phone.partialFormatted(),
            state: {
                guard isLoading == false else {
                    return .disabled
                }
                return self.phone == nil ? .empty : .correct
            }(),
            caption: ""
        )
        view.updatePhoneField(viewModel: viewModel)
    }

    func updateContinueButton() {
        let isReadyToLogin = isLoading == false && isPhoneValid
        let isReadyToRegister = isLoading == false && isNameValid && isPhoneValid && isCheckboxSelected

        let viewModel = PhoneLogInModels.ContinueButton.ViewModel(
            isEnabled: userRoleStatus == nil ? isReadyToLogin : isReadyToRegister
        )
        view.updateContinueButton(viewModel: viewModel)
    }

    func registerNewAccount() {
        guard let phone else { return }

        isLoading = true
        updateContinueButton()
        Task {
            do {
                if try await authorizationService.registerNewAccount(phone: phone.raw, name: name) {
                    await MainActor.run {
                        isLoading = false
                        updateContinueButton()
                        coordinator.openCode(phone: phone.raw)
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    updateContinueButton()
                }
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }

    func fetchUserStatus(phone: Phone) {
        isLoading = true
        updateContinueButton()
        Task {
            do {
                let status = try await authorizationService.fetchUserStatus(phone: phone.raw)

                await MainActor.run {
                    isLoading = false
                    updateContinueButton()
                    userRoleStatus = status
                    switch status {
                        case .notRegistered:
                            let viewModel = PhoneLogInModels.Registration.ViewModel(
                                phone: phone.partialFormatted(),
                                phoneTextFieldState: .disabled,
                                continueButtonTitle: L10n.PhoneLogIn.Buttons.register,
                                isContinueButtonEnabled: false,
                                isNameTextFieldHidden: false,
                                isPrivacyCheckBoxHidden: false
                            )
                            view.displayRegistration(viewModel: viewModel)

                        case .user, .admin, .barista:
                            coordinator.openCode(phone: phone.raw)

                        case .unknown:
                            break
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    updateContinueButton()
                }
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}

private extension PhoneLogInViewPresenter {
    enum RegExConstants {
        static let validPhoneSymbols = "^\\+?[0-9]+$"
        static let namePattern = "^[А-Яа-я](?!.*[-\\s]{2,})[А-Яа-я\\-\\s]*$"
        static let validSymbols: String = "^[А-Яа-я\\-\\s]+$"
    }
}
