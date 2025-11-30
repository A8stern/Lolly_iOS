//
//  QRSectionViewModel.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

import UIKit

public struct QRViewModel: Changeable {
    public let isSkeletonable: Bool
    public let qrImage: UIImage?

    public init(
        isSkeletonable: Bool = false,
        qrImage: UIImage? = nil
    ) {
        self.isSkeletonable = isSkeletonable
        self.qrImage = qrImage
    }
}
