//
//  ContactsInfoResponse.swift
//  LOLLY
//
//  Created by Nikita on 12.11.2025.
//

import Foundation

struct ContactsInfoResponseModel: ResponseModel {
    let image: String
    let text: String
    let places: [PlaceResponseModel]
    let website: [WebSiteResponseModel]
    let socialMedias: [SocialMediaResponseModel]
}
