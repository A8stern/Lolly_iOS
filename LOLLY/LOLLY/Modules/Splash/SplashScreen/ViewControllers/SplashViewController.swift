//
//  SplashView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 20.10.2025.
//

internal import UIKit

protocol SplashView: AnyObject { }

final class SplashViewController: UIViewController {
    // MARK: - Internal Properties

    var presenter: SplashPresenter?

    // MARK: - Private Properties

    private lazy var spinnerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.ImageName.spinner))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
        setupViews()

        presenter?.onViewDidLoad()
    }
}

// MARK: - Private methods

private extension SplashViewController {
    func addSubviews() {
        view.addSubview(spinnerImageView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinnerImageView.heightAnchor.constraint(equalToConstant: Constants.spinnerSize),
            spinnerImageView.widthAnchor.constraint(equalToConstant: Constants.spinnerSize),
            spinnerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white


        spinnerImageView.transform = .identity

        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: [.curveLinear],
            animations: { [weak self] in
                guard let self else { return }
                spinnerImageView.transform = CGAffineTransform(rotationAngle: .pi * 2.0)
            },
            completion: { [weak self] _ in
                guard let self else { return }
                startSpinnerAnimation(on: spinnerImageView)
            }
        )
    }

    func startSpinnerAnimation(on imageView: UIImageView) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = CGFloat.pi * 2.0
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

// MARK: - SplashView

extension SplashViewController: SplashView { }

// MARK: - Constants

private extension SplashViewController {
    enum Constants {
        static let spinnerSize: CGFloat = 22.0
        enum ImageName {
            static let spinner: String = "spinner"
        }
    }
}
