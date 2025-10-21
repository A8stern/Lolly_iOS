//
//  CoordinatorDelegateProxy.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

import Foundation

final class CoordinatorDelegateProxy {
    weak var originalDelegate: CoordinatorDelegate?
    weak var fakeDelegate: CoordinatorDelegate?
}

// MARK: CoordinatorDelegate

extension CoordinatorDelegateProxy: CoordinatorDelegate {
    func coordinatorDidClose(_ coordinator: some Coordinator) {
        originalDelegate?.coordinatorDidClose(coordinator)
        fakeDelegate?.coordinatorDidClose(coordinator)
    }
}
