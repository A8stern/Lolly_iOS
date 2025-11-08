//
//  SystemBrowserRoute.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

import SafariServices
import UIKit

public protocol SystemBrowserRoute {
    func openInSafari(url: URL)
    func openInApp(url: URL)
}

public extension SystemBrowserRoute where Self: Coordinator, RootType: UIViewController {
    func openInSafari(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func openInApp(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        let safariController = SFSafariViewController(url: url)
        root.present(safariController, animated: true)
    }
}
