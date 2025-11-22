//
//  ContactsInfoResponseModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 22.11.2025.
//

import Foundation

public struct ContactsInfo {
    public let imageURL: URL?
    public let title: String
    public let places: [Place]
    public let website: [WebSite]
    public let socialMedias: [SocialMedia]

    public init(
        imageURL: URL?,
        title: String,
        places: [Place],
        website: [WebSite],
        socialMedias: [SocialMedia]
    ) {
        self.imageURL = imageURL
        self.title = title
        self.places = places
        self.website = website
        self.socialMedias = socialMedias
    }
}
