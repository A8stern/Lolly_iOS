//
//  Website.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 22.11.2025.
//

import Foundation

public struct WebSite {
    public let link: URL?
    public let text: String

    public init(link: URL?, text: String) {
        self.link = link
        self.text = text
    }
}
