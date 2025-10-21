//
//  MainView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

protocol MainView: AnyObject {
//    func displaySomething()
//    func displayBanners()
//    func showSnackbarError(_ error: String?)
}

final class MainViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: MainPresenter?

    // MARK: - Private properties

    // MARK: - Views

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()

        presenter?.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
}

// MARK: - Private methods

private extension MainViewController {
    func addSubviews() { }

    func setupConstraints() { }

    func setupViews() {
        view.backgroundColor = UIColor.systemPink
    }
}

// MARK: - MainView

extension MainViewController: MainView { }
