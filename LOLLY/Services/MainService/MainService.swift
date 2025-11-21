//
//  MainService.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

import Foundation

public final class MainService: MainServiceInterface {
    private let networkService: NetworkService

    private let calendarMapper: CalendarMapperInterface
    private let gamificationMapper: GamificationMapperInterface
    private let loyaltyMapper: LoyaltyMapperInterface
    private let marketingMapper: MarketingMapperInterface

    // MARK: Lifecycle

    public init(
        calendarMapper: CalendarMapperInterface,
        gamificationMapper: GamificationMapperInterface,
        loyaltyMapper: LoyaltyMapperInterface,
        marketingMapper: MarketingMapperInterface,
        networkService: NetworkService
    ) {
        self.calendarMapper = calendarMapper
        self.gamificationMapper = gamificationMapper
        self.loyaltyMapper = loyaltyMapper
        self.marketingMapper = marketingMapper
        self.networkService = networkService
    }

    // MARK: Public Methods

    public func getContactsData() async throws -> [String: Any] {
        let endpoint = ContactsEndpoint.getContactsData
        let DTOData: ContactsInfoResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )

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

    public func getAfisha() async throws -> String {
        let body = EmptyRequestModel()
        let endpoint = MarketingEndpoint.afisha

        let response: AfishaResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )
        return response.text
    }

    public func getSlider() async throws -> [SliderCard] {
        let body = EmptyRequestModel()
        let endpoint = MarketingEndpoint.slider

        let response: SliderResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        let result: [SliderCard] = marketingMapper.map(response)
        return result
    }

    public func getGamifacitaionOverview() async throws -> GamificationOverview {
        let body = EmptyRequestModel()
        let endpoint = GamificationEndpoint.overview

        let response: GamificationOverviewResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        let result = gamificationMapper.map(response)
        return result
    }

    public func getCalendarOverview() async throws -> [Day] {
        let body = EmptyRequestModel()
        let endpoint = CalendarEndpoint.overview

        let response: CalendarOverviewResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        let result = calendarMapper.map(response)
        return result
    }

    public func getLoyaltyStatus() async throws -> LoyaltyStatus {
        let body = EmptyRequestModel()
        let endpoint = LoyaltyEndpoint.status

        let response: LoyaltyStatusResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            body: body,
            headers: endpoint.headers
        )

        let result = loyaltyMapper.map(response)
        return result
    }
}
