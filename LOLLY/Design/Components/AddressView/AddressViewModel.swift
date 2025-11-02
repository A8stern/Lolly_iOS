//
//  AddressViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 02.11.2025.
//

public struct AddressViewModel: Changeable {
    public let address: String
    public let description: String?

    public init(
        address: String,
        description: String?
    ) {
        self.address = address
        self.description = description
    }
}
