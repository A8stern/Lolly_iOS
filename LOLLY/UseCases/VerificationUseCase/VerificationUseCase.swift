//
//  VerificationUseCase.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

import Foundation

public final class VerificationUseCase: VerificationUseCaseInterface {
    // MARK: - Public Properties

    public weak var delegate: VerificationUseCaseDelegate? {
        didSet {
            guard let runningTimerRemainingSeconds, runningTimerRemainingSeconds > .zero else { return }
            delegate?.verificationUseCaseDidStartTimer(nextAttemptIn: runningTimerRemainingSeconds)
        }
    }

    // MARK: - Private Properties

    /// Текущий таймер
    private var runningTimer: Timer?

    /// Время завершения текущего таймера
    private var runningTimerFinishDate: Date?

    /// Оставшееся время текущего таймера
    private var runningTimerRemainingSeconds: Int? {
        guard let runningTimerFinishDate else { return nil }
        return Int(ceil(runningTimerFinishDate.timeIntervalSince(Date())))
    }

    // MARK: - Lifecycle

    public init() { }

    // MARK: - Public Methods

    public func startOtpTimer() {
        guard runningTimer?.isValid == false || runningTimer == nil else {
            return
        }

        startTimer()
    }

    public func stopOtpTimer() {
        stopTimer()
    }
}

// MARK: - Private Methods

extension VerificationUseCase {
    fileprivate func startTimer() {
        let finishDate = Date().appending(DateComponents(second: 60))
        let timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.handleTimerTick()
        })
        runningTimer = timer
        runningTimerFinishDate = finishDate
        RunLoop.main.add(timer, forMode: .common)
        delegate?.verificationUseCaseDidTick(nextAttemptIn: 60)
    }

    fileprivate func stopTimer() {
        runningTimer?.invalidate()
        delegate?.verificationUseCaseDidStopTimer()
        runningTimer = nil
        runningTimerFinishDate = nil
    }

    fileprivate func handleTimerTick() {
        guard let runningTimerRemainingSeconds, runningTimerRemainingSeconds > .zero else {
            stopTimer()
            return
        }
        delegate?.verificationUseCaseDidTick(nextAttemptIn: runningTimerRemainingSeconds)
    }
}
