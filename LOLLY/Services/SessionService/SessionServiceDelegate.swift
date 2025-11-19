//
//  SessionServiceDelegate.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 18.11.2025.
//

import Foundation

public protocol SessionServiceDelegate: AnyObject {
    func sessionServiceDidSignOut()
}
