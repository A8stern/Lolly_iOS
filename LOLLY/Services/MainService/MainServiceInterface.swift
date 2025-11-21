//
//  MainServiceInterface.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

public protocol MainServiceInterface: AnyObject {
    func getContactsData() async throws -> [String: Any]
    func getAfisha() async throws -> String
    func getSlider() async throws -> [SliderCard]
    func getGamifacitaionOverview() async throws -> GamificationOverview
    func getCalendarOverview() async throws -> [Day]
    func getLoyaltyStatus() async throws -> LoyaltyStatus
}
