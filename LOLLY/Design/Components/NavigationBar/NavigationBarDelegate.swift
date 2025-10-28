//
//  NavigationBarDelegate.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 28.10.2025.
//

public protocol NavigationBarDelegate: AnyObject {
    func didReceiveBackAction(_ navigationBar: NavigationBar)
    func didReceiveCloseAction(_ navigationBar: NavigationBar)
}

public extension NavigationBarDelegate {
    func didReceiveBackAction(_ navigationBar: NavigationBar) { }
    func didReceiveCloseAction(_ navigationBar: NavigationBar) { }
}
