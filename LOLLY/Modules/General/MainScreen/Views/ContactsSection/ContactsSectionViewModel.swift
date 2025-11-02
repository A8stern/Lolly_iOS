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

    public init(
        title: String?,
        backgroundImage: UIImage,
        addresses: [AddressViewModel]
    ) {
        self.title = title
        self.backgroundImage = backgroundImage
        self.addresses = addresses
    }
}
