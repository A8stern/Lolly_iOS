//
//  ViewModellable.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 25.10.2025.
//

public protocol ViewModellable {
    associatedtype ViewModel

    var viewModel: ViewModel { get set }

    init(viewModel: ViewModel)
}

// MARK: ViewModellableBox

public struct ViewModellableBox<V: ViewModellable> {
    public typealias Boxed = V
    public typealias ViewModel = V.ViewModel

    public let viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension ViewModellable {
    public static func box(with viewModel: Self.ViewModel) -> ViewModellableBox<Self> {
        ViewModellableBox(
            viewModel: viewModel
        )
    }
}
