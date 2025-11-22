//
//  ContactsSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 01.11.2025.
//

import UIKit

public struct ContactsSectionViewModel: Changeable {
    public let isSkeletonable: Bool
    public let title: String?
    public let backgroundImageURL: URL?
    public let addresses: [AddressViewModel]
    public let socialButtonViewModels: [SocialCircleButtonViewModel]
    public let buttons: [ButtonViewModel]

    public init(
        isSkeletonable: Bool = false,
        title: String? = nil,
        backgroundImageURL: URL? = nil,
        addresses: [AddressViewModel] = [],
        socialButtonViewModels: [SocialCircleButtonViewModel] = [],
        buttons: [ButtonViewModel] = []
    ) {
        self.isSkeletonable = isSkeletonable
        self.title = title
        self.backgroundImageURL = backgroundImageURL
        self.addresses = addresses
        self.socialButtonViewModels = socialButtonViewModels
        self.buttons = buttons
    }
}
