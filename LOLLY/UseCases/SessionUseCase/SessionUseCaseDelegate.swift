//
//  SessionUseCaseDelegate.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

// MARK: - Delegate

public protocol SessionUseCaseDelegate: AnyObject {
    func sessionUseCaseDidSignOut()
}
