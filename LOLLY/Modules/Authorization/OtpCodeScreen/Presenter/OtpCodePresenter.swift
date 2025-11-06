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
}

final class OtpCodeViewPresenter {
    // MARK: - Private Properties

    private unowned let view: OtpCodeView
    private let coordinator: AuthCoordinator
    private let authorizationService: AuthorizationServiceInterface
    private let phone: String

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
        phone: String,
        authorizationService: AuthorizationServiceInterface
    ) {
        self.view = view
        self.coordinator = coordinator
        self.phone = phone
        self.authorizationService = authorizationService
    }
}

// MARK: - AuthMethodsPresenter

extension OtpCodeViewPresenter: OtpCodePresenter {
    func onViewDidLoad() {
        Task { [weak self] in
            await self?.requestOTPWithRetries()
        }
    }

    func onViewWillAppear() { }

    func onViewDidAppear() { }

    func checkOTP(code: String) {
        Task {
            do {
                if try await authorizationService.otpVerify(phone: phone, otp: code) {
                    await MainActor.run {
                        coordinator.close(animated: true)
                    }
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Private Methods

private extension OtpCodeViewPresenter {
    func responseInitialData(response: AuthMethodsModels.InitialData.Response) {
    }

    func requestOTPWithRetries() async {
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
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        delay *= RetryConfig.backoffMultiplier
                        continue
                    } else {
                        return
                    }
                }
            } catch {
                if attempt < RetryConfig.maxAttempts {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    delay *= RetryConfig.backoffMultiplier
                    continue
                } else {
                    return
                }
            }
        }
    }
}
