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
    private let contactsMapper: ContactsMapperInterface

    // MARK: Lifecycle

    public init(
        calendarMapper: CalendarMapperInterface,
        gamificationMapper: GamificationMapperInterface,
        loyaltyMapper: LoyaltyMapperInterface,
        marketingMapper: MarketingMapperInterface,
        contactsMapper: ContactsMapperInterface,
        networkService: NetworkService
    ) {
        self.calendarMapper = calendarMapper
        self.gamificationMapper = gamificationMapper
        self.loyaltyMapper = loyaltyMapper
        self.marketingMapper = marketingMapper
        self.contactsMapper = contactsMapper
        self.networkService = networkService
    }

    // MARK: Public Methods

    public func getContactsData() async throws -> ContactsInfo {
        let endpoint = ContactsEndpoint.getContactsData
        let response: ContactsInfoResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )

        let result = contactsMapper.map(response)
        return result
    }

    public func getAfisha() async throws -> String {
        let endpoint = MarketingEndpoint.afisha

        let response: AfishaResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )
        return response.text
    }

    public func getSlider() async throws -> [SliderCard] {
        let endpoint = MarketingEndpoint.slider

        let response: SliderResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )

        let result: [SliderCard] = marketingMapper.map(response)
        return result
    }

    public func getGamifacitaionOverview() async throws -> GamificationOverview {
        let endpoint = GamificationEndpoint.overview

        let response: GamificationOverviewResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )

        let result = gamificationMapper.map(response)
        return result
    }

    public func getCalendarOverview() async throws -> [Day] {
        let endpoint = CalendarEndpoint.overview

        let response: CalendarOverviewResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )

        let result = calendarMapper.map(response)
        return result
    }

    public func getLoyaltyStatus() async throws -> LoyaltyStatus {
        let endpoint = LoyaltyEndpoint.status

        let response: LoyaltyStatusResponseModel = try await networkService.request(
            endpoint: endpoint.endpoint,
            method: endpoint.method,
            headers: endpoint.headers
        )

        let result = loyaltyMapper.map(response)
        return result
    }
}
