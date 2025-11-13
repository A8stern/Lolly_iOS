//
//  ContactsInfoResponse.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

import Foundation

struct PlaceDTO: Decodable {
    let location: String
    let text: String
}

struct WebSiteDTO: Decodable {
    let link: String
    let text: String
}

struct SocialMediaDTO: Decodable {
    let imageURL: String
    let link: String
}

// MARK: Main struct(DTO)

struct ContactsInfoResponse: Decodable {
    let image: String
    let text: String
    let places: [PlaceDTO]
    let website: [WebSiteDTO]
    let socialMedias: [SocialMediaDTO]
}
