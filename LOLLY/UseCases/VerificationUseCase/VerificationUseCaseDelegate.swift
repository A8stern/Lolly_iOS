//
//  VerificationUseCaseDelegate.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

public protocol VerificationUseCaseDelegate: AnyObject {
    /// Запуск таймера до повторной попытка отправки запроса.
    func verificationUseCaseDidStartTimer(nextAttemptIn secondsLeft: Int)

    /// Уведомление об оставшемся времени до повторной попытки отправки запроса.
    func verificationUseCaseDidTick(nextAttemptIn secondsLeft: Int)

    /// Завершение таймера повторной попытки отправки запроса.
    func verificationUseCaseDidStopTimer()
}
