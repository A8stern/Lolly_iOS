//
//  ContactsSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 01.11.2025.
//

import UIKit

public struct ContactsSectionViewModel: Changeable {
    var title: String?
    var backgroundImage: UIImage
    var addresses: [AddressViewModel]
    var socialButtonViewModels: [SocialCircleButtonViewModel]
    var websiteButton: ButtonViewModel

    public init(
        title: String?,
        backgroundImage: UIImage,
        addresses: [AddressViewModel],
        socialButtonViewModels: [SocialCircleButtonViewModel],
        websiteButton: ButtonViewModel
    ) {
        self.title = title
        self.backgroundImage = backgroundImage
        self.addresses = addresses
        self.socialButtonViewModels = socialButtonViewModels
        self.websiteButton = websiteButton
    }
}
