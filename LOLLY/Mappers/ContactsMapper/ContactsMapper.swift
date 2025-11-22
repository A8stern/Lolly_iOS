//
//  ContactsMapper.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 23.11.2025.
//

import Foundation

public final class ContactsMapper {
    public init() { }

    private func map(_ response: [PlaceResponseModel]) -> [Place] {
        response.map {
            Place(
                location: $0.location,
                text: $0.text
            )
        }
    }

    private func map(_ response: [WebSiteResponseModel]) -> [WebSite] {
        response.map {
            WebSite(
                link: URL(string: $0.link),
                text: $0.text
            )
        }
    }

    private func map(_ response: [SocialMediaResponseModel]) -> [SocialMedia] {
        response.map {
            SocialMedia(
                imageURL: URL(string: $0.imageURL),
                link: URL(string: $0.link)
            )
        }
    }
}

// MARK: - ContactsMapperInterface

extension ContactsMapper: ContactsMapperInterface {
    public func map(_ response: ContactsInfoResponseModel) -> ContactsInfo {
        ContactsInfo(
            imageURL: URL(string: response.image),
            title: response.text,
            places: map(response.places),
            website: map(response.website),
            socialMedias: map(response.socialMedias)
        )
    }
}
