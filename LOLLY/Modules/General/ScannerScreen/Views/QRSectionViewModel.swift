//
//  ScannerViewModel.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

import UIKit

public struct QRSectionViewModel: Changeable {
    public let qrImage: UIImage?
    public let text: String

    public init(qrImage: UIImage?, text: String) {
        self.qrImage = qrImage
        self.text = text
    }
}
