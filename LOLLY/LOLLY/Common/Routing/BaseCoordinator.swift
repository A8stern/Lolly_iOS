//
//  BaseCoordinator.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

public import UIKit

open class BaseCoordinator<RootType: Presenter>: NSObject, Coordinator, CoordinatorDelegate {
    // MARK: - Public Properties

    public let root: RootType

    public weak var delegate: CoordinatorDelegate? {
        get {
            delegateProxy.originalDelegate
        }
        set {
            delegateProxy.originalDelegate = newValue
        }
    }

    @Atomic public private(set) var children: [any Coordinator] = []

    // MARK: - Private Properties

    internal var delegateProxy = CoordinatorDelegateProxy()

    // MARK: - Lifecycle

    public init(root: RootType) {
        self.root = root
        super.init()
    }

    deinit {
        children.removeAll()
    }

    // MARK: - Public Methods

    open func add(child coordinator: any Coordinator) {
        if let baseCoordinator = coordinator as? BaseCoordinator {
            baseCoordinator.delegateProxy.fakeDelegate = self
        } else {
            coordinator.delegate = self
        }
        children.append(coordinator)
    }

    open func remove(child coordinator: any Coordinator) {
        children.removeAll(where: { coordinator === $0 })
    }

    open func removeAll() {
        children = []
    }

    open func start() {
        assertionFailure("this method must be overridden")
    }

    open func close(animated: Bool = true) {
        switch root {
            case let root as UIViewController:
                root.dismiss(animated: animated, completion: { [weak self] in
                    guard let self else { return }
                    self.didClosed()
                })

            default:
                break
        }
    }

    open func didClosed() {
        self.delegateProxy.coordinatorDidClose(self)
    }

    // MARK: - CoordinatorDelegate

    open func coordinatorDidClose(_ coordinator: some Coordinator) {
        remove(child: coordinator)
    }
}

