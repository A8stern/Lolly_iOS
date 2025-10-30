//
//  EventViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

public struct EventViewModel: Changeable {
    public let title: String
    public let subtitle: String

    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}
