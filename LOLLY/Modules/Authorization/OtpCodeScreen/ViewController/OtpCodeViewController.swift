//
//  OtpCodeViewController.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

private import PhoneNumberKit
private import SnapKit
import UIKit

protocol OtpCodeView: AnyObject {
    func displayResendButton(viewModel: OtpCodeModels.ResendButton.ViewModel)
}

final class OtpCodeViewController: UIViewController {
    var presenter: OtpCodePresenter?

    // MARK: - Private views

    private lazy var codeTextField: CodeTextField = {
        let field = CodeTextField()
        field.length = Constants.codeLength
        field.boxSize = .init(
            width: Constants.codeBoxWidthRatio * UIScreen.main.bounds.width,
            height: Constants.codeBoxWidthRatio * UIScreen.main.bounds.width
        )
        field.cornerRadius = Constants.codeBoxCornerRadius
        field.spacing = Constants.codeBoxSpacingRatio * UIScreen.main.bounds.width

        field.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
        field.onCodeFilled = { [weak self] code in
            guard let self else { return }
            presenter?.checkOTP(code: code)
        }

        return field
    }()

    private lazy var enterCodeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Styles.caption
        label.textColor = UIColor(asset: Colors.Text.primary)
        label.text = L10n.Otp.Verification.caption
        return label
    }()

    private lazy var resendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Colors.accentColor.color, for: .normal)
        button.setTitleColor(Colors.Text.secondary.color, for: .disabled)
        button.titleLabel?.font = Fonts.Styles.caption

        button.addTarget(self, action: #selector(didTapResend), for: .touchUpInside)

        return button
    }()

    private lazy var openTelegramBotButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(L10n.Otp.Verification.telegram, for: .normal)
        button.setTitleColor(Colors.accentColor.color, for: .normal)
        button.setTitleColor(Colors.Text.secondary.color, for: .disabled)
        button.titleLabel?.font = Fonts.Styles.caption
        button.addTarget(self, action: #selector(didTapTelegramBotButton), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        setupKeyboardDismissGesture()
        presenter?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.onViewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter?.onViewDidDisappear()
    }

    // MARK: - Private setup

    private func addSubviews() {
        view.addSubview(codeTextField)
        view.addSubview(enterCodeLabel)
        view.addSubview(resendCodeButton)
        view.addSubview(openTelegramBotButton)
    }

    private func setupConstraints() {
        codeTextField.snp.makeConstraints { make in
            let screenHeight = UIScreen.main.bounds.height
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.codeBoxTopOffsetRatio * screenHeight)
            make.left.equalToSuperview().offset(Constants.codeBoxSideInset)
            make.right.equalToSuperview().inset(Constants.codeBoxSideInset)
            make.height.greaterThanOrEqualTo(codeTextField.boxSize.height)
        }
        enterCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(Constants.labelTopOffset)
            make.left.right.equalTo(codeTextField)
            make.height.equalTo(Constants.labelHeight)
        }
        resendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(enterCodeLabel.snp.bottom).offset(Constants.resendButtonTopOffset)
            make.centerX.equalTo(codeTextField)
            make.width.equalTo(codeTextField)
            make.height.equalTo(Constants.buttonHeight)
        }
        openTelegramBotButton.snp.makeConstraints { make in
            make.top.equalTo(resendCodeButton.snp.bottom).offset(Constants.telegramButtonTopOffset)
            make.centerX.equalTo(codeTextField)
            make.width.equalTo(codeTextField)
            make.height.equalTo(Constants.buttonHeight)
        }
    }

    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions

    @objc
    private func didTapResend() { }

    @objc
    private func didTapTelegramBotButton() {
        presenter?.onTelegramBotButtonTap()
    }

    @objc
    private func codeChanged() { }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Conformance to AuthEnterPhoneView

extension OtpCodeViewController: OtpCodeView {
    func displayResendButton(viewModel: OtpCodeModels.ResendButton.ViewModel) {
        resendCodeButton.isEnabled = viewModel.isResendButtonEnabled

        UIView.performWithoutAnimation { [self] in
            resendCodeButton.setTitle(viewModel.resendButtonTitle, for: [])
            resendCodeButton.layoutIfNeeded()
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let codeLength: Int = 4
    static let codeBoxWidthRatio: CGFloat = 68.0 / 390.0
    static let codeBoxCornerRadius: CGFloat = 14
    static let codeBoxSpacingRatio: CGFloat = 23.33 / 390.0
    static let codeBoxTopOffsetRatio: CGFloat = 234.0 / 844.0
    static let codeBoxSideInset: CGFloat = 24

    static let labelTopOffset: CGFloat = 16
    static let labelHeight: CGFloat = 18

    static let resendButtonTopOffset: CGFloat = 32
    static let telegramButtonTopOffset: CGFloat = 12
    static let buttonHeight: CGFloat = 18
}
