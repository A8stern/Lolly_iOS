//
//  SocialMedia.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 22.11.2025.
//

import Foundation

public struct SocialMedia {
    public let imageURL: URL?
    public let link: URL?

    public init(imageURL: URL?, link: URL?) {
        self.imageURL = imageURL
        self.link = link
    }
}
