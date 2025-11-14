//
//  OtpCodePresenter.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

internal import UIKit

protocol OtpCodePresenter: AnyObject {
    /// Обработка входа на экран.
    func onViewDidLoad()

    /// События показа экрана
    func onViewWillAppear()

    /// Триггер загрузки данных
    func onViewDidAppear()

    // Проверка ОТП кода введенного
    func checkOTP(code: String)

    /// Обработка закрытия
    func onViewDidDisappear()

    func onTelegramBotButtonTap()
}

final class OtpCodeViewPresenter {
    // MARK: - Private Properties

    private unowned let view: OtpCodeView
    private let coordinator: AuthCoordinator
    private let verificationUseCase: VerificationUseCaseInterface
    private let authorizationService: AuthorizationServiceInterface
    private let phone: String
    private let telegramUrl: URL? = URL(string: "https://t.me/kprokofyev")

    /// Текущий таймер
    private var runningTimer: Timer?

    /// Время завершения текущего таймера
    private var runningTimerFinishDate: Date?

    /// Оставшееся время текущего таймера
    private var runningTimerRemainingSeconds: Int? {
        guard let runningTimerFinishDate else { return nil }
        return Int(ceil(runningTimerFinishDate.timeIntervalSince(Date())))
    }

    // Настройки повторных попыток
    private enum RetryConfig {
        static let maxAttempts: Int = 3
        static let initialDelaySeconds: Double = 1.0
        static let backoffMultiplier: Double = 2.0
    }

    // MARK: - Initialization

    init(
        view: OtpCodeView,
        coordinator: AuthCoordinator,
        verificationUseCase: VerificationUseCaseInterface,
        phone: String,
        authorizationService: AuthorizationServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.phone = phone
        self.verificationUseCase = verificationUseCase
        self.authorizationService = authorizationService

        verificationUseCase.delegate = self
    }

    deinit {
        verificationUseCase.delegate = nil
    }
}

// MARK: - AuthMethodsPresenter

extension OtpCodeViewPresenter: OtpCodePresenter {
    func onViewDidLoad() {
        verificationUseCase.startOtpTimer()

        let viewModel = OtpCodeModels.ResendButton.ViewModel(
            resendButtonTitle: L10n.Otp.Verification.resendCode,
            isResendButtonEnabled: false
        )
        view.displayResendButton(viewModel: viewModel)

        Task { [weak self] in
            await self?.requestOTPWithRetries()
        }
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func onViewDidDisappear() {
        verificationUseCase.stopOtpTimer()
        coordinator.close(animated: true)
    }

    func checkOTP(code: String) {
        Task {
            do {
                if try await authorizationService.otpVerify(phone: phone, otp: code) {
                    await MainActor.run {
                        coordinator.close(animated: true)
                    }
                }
            } catch {
                await MainActor.run {
                    view.showSnack(with: .error(text: error.localizedDescription))
                }
            }
        }
    }

    func onTelegramBotButtonTap() {
        guard let telegramUrl else { return }
        coordinator.openInSafari(url: telegramUrl)
    }
}

// MARK: - Private Methods

extension OtpCodeViewPresenter {
    fileprivate func responseInitialData(response _: AuthMethodsModels.InitialData.Response) { }

    fileprivate func requestOTPWithRetries() async {
        var attempt = 0
        var delay = RetryConfig.initialDelaySeconds

        while attempt < RetryConfig.maxAttempts {
            attempt += 1
            do {
                let success = try await authorizationService.otpRequest(phone: phone)
                if success {
                    return
                } else {
                    if attempt < RetryConfig.maxAttempts {
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1000000000))
                        delay *= RetryConfig.backoffMultiplier
                        continue
                    } else {
                        return
                    }
                }
            } catch {
                if attempt < RetryConfig.maxAttempts {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1000000000))
                    delay *= RetryConfig.backoffMultiplier
                    continue
                } else {
                    return
                }
            }
        }
    }

    fileprivate func startTimer() {
        let finishDate = Date().appending(DateComponents(second: Constants.resendButtonAppearDelayInSeconds))
        let timer = Timer(fire: finishDate, interval: .zero, repeats: false) { [weak self] _ in
            guard let self else { return }

            let viewModel = OtpCodeModels.ResendButton.ViewModel(
                resendButtonTitle: L10n.Otp.Verification.resendCode,
                isResendButtonEnabled: true
            )
            view.displayResendButton(viewModel: viewModel)
            runningTimer?.invalidate()
            runningTimer = nil
        }
        runningTimer = timer
        runningTimerFinishDate = finishDate
        RunLoop.main.add(timer, forMode: .common)
    }
}

extension OtpCodeViewPresenter: VerificationUseCaseDelegate {
    func verificationUseCaseDidStartTimer(nextAttemptIn secondsLeft: Int) {
        let viewModel = OtpCodeModels.ResendButton.ViewModel(
            resendButtonTitle: L10n.Otp.Verification.resendCode + " \(secondsLeft.timeFormatted)",
            isResendButtonEnabled: false
        )
        view.displayResendButton(viewModel: viewModel)
    }

    func verificationUseCaseDidTick(nextAttemptIn secondsLeft: Int) {
        let viewModel = OtpCodeModels.ResendButton.ViewModel(
            resendButtonTitle: L10n.Otp.Verification.resendCode + " \(secondsLeft.timeFormatted)",
            isResendButtonEnabled: false
        )
        view.displayResendButton(viewModel: viewModel)
    }

    func verificationUseCaseDidStopTimer() {
        let viewModel = OtpCodeModels.ResendButton.ViewModel(
            resendButtonTitle: L10n.Otp.Verification.resendCode,
            isResendButtonEnabled: true
        )
        view.displayResendButton(viewModel: viewModel)
    }
}

// MARK: - Constants

extension OtpCodeViewPresenter {
    fileprivate enum Constants {
        static let otpLength = 4
        static let resendButtonAppearDelayInSeconds = 60
    }
}
