//
//  ContactsSectionViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 01.11.2025.
//

import UIKit

public struct ContactsSectionViewModel: Changeable {
    public let isSkeletonable: Bool
    public let  title: String?
    public let  backgroundImage: UIImage?
    public let  addresses: [AddressViewModel]
    public let  socialButtonViewModels: [SocialCircleButtonViewModel]
    public let  websiteButton: ButtonViewModel?

    public init(
        isSkeletonable: Bool = false,
        title: String? = nil,
        backgroundImage: UIImage? = nil,
        addresses: [AddressViewModel] = [],
        socialButtonViewModels: [SocialCircleButtonViewModel] = [],
        websiteButton: ButtonViewModel? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.title = title
        self.backgroundImage = backgroundImage
        self.addresses = addresses
        self.socialButtonViewModels = socialButtonViewModels
        self.websiteButton = websiteButton
    }
}
