//
//  VerificationUseCaseInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

// MARK: - Interface

public protocol VerificationUseCaseInterface: AnyObject {
    /// Делегат.
    var delegate: VerificationUseCaseDelegate? { get set }

    /// Запуск таймера переотправки кода
    func startOtpTimer()

    func stopOtpTimer()
}
