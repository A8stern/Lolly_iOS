//
//  AuthenticationCredential.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

public protocol AuthenticationCredential {
    var requiresRefresh: Bool { get }
}
