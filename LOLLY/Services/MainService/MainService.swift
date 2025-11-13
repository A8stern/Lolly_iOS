//
//  MainService.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

import Foundation

public final class MainService: MainServiceInterface {
    private let networkService: NetworkService

    // MARK: Lifecycle

    public init(networkService: NetworkService, isMock: Bool) {
        self.networkService = networkService
    }

    // MARK: Public Methods

    public func getContactsData() async throws -> [String: Any] {
        let endpoint = ContactsEndPoint.getContactsData
        print("ENO")
        let DTOData: ContactsInfoResponse = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )
        print(DTOData.text, "POINT")

        let placesArray: [[String: Any]] = DTOData.places.map { place in
            [
                "location": place.location,
                "text": place.text
            ]
        }

        let websiteArray: [[String: Any]] = DTOData.website.map { site in
            [
                "link": site.link,
                "text": site.text
            ]
        }

        let socialMediasArray: [[String: Any]] = DTOData.socialMedias.map { social in
            [
                "imageURL": social.imageURL,
                "link": social.link
            ]
        }

        let jsonData: [String: Any] = [
            "image": DTOData.image,
            "text": DTOData.text,
            "places": placesArray,
            "website": websiteArray,
            "socialMedias": socialMediasArray
        ]

        return jsonData
    }
}
