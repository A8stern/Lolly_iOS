private import SnapKit

//
//  MainViewController.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

internal import UIKit

protocol ScannerView: AnyObject {
    func displayInitialData(viewModel: ScannerModels.InitialData.ViewModel)
}

final class ScannerViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: ScannerPresenter?

    // MARK: - Private properties

    // MARK: - Views

    private lazy var QRSection: QRSectionView = {
        let section = QRSectionView()
        return section
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Text.inverted.color
        button.setImage(Assets.Controls.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(onCloseTap), for: .touchUpInside)
        return button
    }()

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.onViewWillDisappear()
    }
}

extension ScannerViewController {
    @objc
    fileprivate func onCloseTap() {
        presenter?.onCloseTap()
    }

    fileprivate func addSubviews() {
        view.addSubview(QRSection)
        view.addSubview(closeButton)
    }

    fileprivate func setupConstraints() {
        QRSection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            make.width.greaterThanOrEqualTo(44)
            make.height.greaterThanOrEqualTo(44)
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - MainView

extension ScannerViewController: ScannerView {
    func displayInitialData(viewModel: ScannerModels.InitialData.ViewModel) {
        QRSection.viewModel = viewModel.QRSectionViewModel
    }
}

// MARK: - NavigationBarDelegate

// MARK: - Constants

extension ScannerViewController {
    fileprivate enum Constants {
        static let innerMargins: UIEdgeInsets = .zero
        static let contentMargins: UIEdgeInsets = .zero
        static let qrSize: CGFloat = 325.0
    }
}
