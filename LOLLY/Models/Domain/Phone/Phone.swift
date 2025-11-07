//
//  Phone.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

private import PhoneNumberKit

public struct Phone {
    let raw: String

    public init(raw: String) {
        self.raw = raw
    }
}

extension Phone {
    public func partialFormatted() -> String {
        return PartialFormatter().formatPartial(raw)
    }
}
