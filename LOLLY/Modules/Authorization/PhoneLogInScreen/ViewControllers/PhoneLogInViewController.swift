//
//  PhoneLogInViewController.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

private import SnapKit
import UIKit

protocol PhoneLogInView: AnyObject {
    func displayInitialData(viewModel: PhoneLogInModels.InitialData.ViewModel)
    func displayRegistration(viewModel: PhoneLogInModels.Registration.ViewModel)
    func updatePhoneField(viewModel: PhoneLogInModels.PhoneField.ViewModel)
    func updateNameField(viewModel: PhoneLogInModels.NameField.ViewModel)
    func updateContinueButton(viewModel: PhoneLogInModels.ContinueButton.ViewModel)
}

final class PhoneLogInViewController: UIViewController {
    var presenter: PhoneLogInPresenter?

    // MARK: - Private views

    private lazy var contentStackView: StackView = {
        let stackView = StackView(axis: .vertical, space: 16)
        return stackView
    }()

    private lazy var phoneTextField: TextField = {
        let field = TextField()
        field.title = L10n.PhoneLogIn.Phone.title
        field.placeholder = L10n.PhoneLogIn.Phone.placeholder
        field.keyboardType = .numberPad
        return field
    }()

    private lazy var nameTextField: TextField = {
        let field = TextField()
        field.title = L10n.PhoneLogIn.Name.title
        field.placeholder = L10n.PhoneLogIn.Name.placeholder
        return field
    }()

    private lazy var privacyCheckBox: LabeledCheckbox = {
        let checkbox = LabeledCheckbox()
        let baseFont = Fonts.TTTravels.regular.font(size: 13)
        checkbox.attributedText = makeTermsAttributedText(baseFont: baseFont)
        return checkbox
    }()

    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var continueButton: Button = {
        let button = Button()
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        setupBehavior()
        setupKeyboardDismissGesture()
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

    // MARK: - Private setup

    private func addSubviews() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(
            phoneTextField,
            nameTextField,
            privacyCheckBox
        )
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(continueButton)
    }

    private func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            make.bottom.equalTo(view.snp.centerY)
        }
        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY)
            make.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        continueButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupBehavior() {
        phoneTextField.delegate = self
        nameTextField.delegate = self
    }

    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func setRegisterVisibility(
        isNameTextFieldHidden: Bool,
        isPrivacyCheckBoxHidden: Bool,
        withAnimation: Bool
    ) {
        let duration = withAnimation ? 0.5 : 0.0
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else { return }
            nameTextField.alpha = isNameTextFieldHidden ? 0 : 1
            privacyCheckBox.alpha = isPrivacyCheckBoxHidden ? 0 : 1
        }
    }

    // MARK: - Actions

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - PhoneLogInView

extension PhoneLogInViewController: PhoneLogInView {
    func displayInitialData(viewModel: PhoneLogInModels.InitialData.ViewModel) {
        continueButton.viewModel = viewModel.continueButtonViewModel
        continueButton.isEnabled = viewModel.isContinueButtonEnabled
        setRegisterVisibility(
            isNameTextFieldHidden: viewModel.isNameTextFieldHidden,
            isPrivacyCheckBoxHidden: viewModel.isPrivacyCheckBoxHidden,
            withAnimation: false
        )
        privacyCheckBox.tapHandler = viewModel.onPrivacyCheckboxTap
    }

    func displayRegistration(viewModel: PhoneLogInModels.Registration.ViewModel) {
        phoneTextField.text = viewModel.phone
        phoneTextField.state = viewModel.phoneTextFieldState
        continueButton.isEnabled = viewModel.isContinueButtonEnabled
        continueButton.viewModel = continueButton.viewModel?.changing {
            $0.title = viewModel.continueButtonTitle
        }
        setRegisterVisibility(
            isNameTextFieldHidden: viewModel.isNameTextFieldHidden,
            isPrivacyCheckBoxHidden: viewModel.isPrivacyCheckBoxHidden,
            withAnimation: true
        )
    }

    func updateNameField(viewModel: PhoneLogInModels.NameField.ViewModel) {
        nameTextField.text = viewModel.name
        nameTextField.state = viewModel.state
        nameTextField.caption = viewModel.caption
    }

    func updatePhoneField(viewModel: PhoneLogInModels.PhoneField.ViewModel) {
        phoneTextField.text = viewModel.phone
        phoneTextField.state = viewModel.state
        phoneTextField.caption = viewModel.caption
    }

    func updateContinueButton(viewModel: PhoneLogInModels.ContinueButton.ViewModel) {
        continueButton.isEnabled = viewModel.isEnabled
    }
}

// MARK: - TextFieldDelegate

extension PhoneLogInViewController: TextFieldDelegate {
    func textField(
        _ textField: TextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let nsstring = NSString(string: textField.text)
        let newValue = nsstring.replacingCharacters(in: range, with: string)

        switch textField {
            case self.phoneTextField:
                presenter?.phoneFieldChanged(newValue)

            case self.nameTextField:
                presenter?.nameFieldChanged(newValue)

            default:
                break
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: TextField) {
        switch textField {
            case self.phoneTextField:
                presenter?.phoneFieldEndEditing()

            case self.nameTextField:
                presenter?.nameFieldEndEditing()

            default:
                break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PhoneLogInViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is Button {
            return false
        }
        return true
    }
}

// MARK: - Helpers

private extension PhoneLogInViewController {
    func makeTermsAttributedText(baseFont: UIFont) -> NSMutableAttributedString {
        let text = L10n.PhoneLogIn.Terms.text
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: baseFont,
                .foregroundColor: UIColor.black
            ]
        )
        if let offerRange = text.range(of: L10n.PhoneLogIn.Terms.oferta) {
            let nsRange = NSRange(offerRange, in: text)
            attributed.addAttribute(.link, value: Constants.termsOfferURL, range: nsRange)
        }
        if let privacyRange = text.range(of: L10n.PhoneLogIn.Terms.privacyPolicy) {
            let nsRange = NSRange(privacyRange, in: text)
            attributed.addAttribute(.link, value: Constants.termsPrivacyURL, range: nsRange)
        }
        return attributed
    }
}

// MARK: - Constants

private extension PhoneLogInViewController {
    enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let termsOfferURL = "https://google.com"
        static let termsPrivacyURL = "https://google.com"
    }
}
