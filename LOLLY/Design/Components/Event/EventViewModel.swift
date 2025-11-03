//
//  EventViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 30.10.2025.
//

public struct EventViewModel: Changeable {
    public let title: String
    public let subtitle: String
    public let onTap: (() -> Void)?

    public init(
        title: String,
        subtitle: String,
        onTap: (() -> Void)?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onTap = onTap
    }
}
