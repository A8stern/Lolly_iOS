private import SnapKit

//
//  QRcodeViewController.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

internal import UIKit

protocol QRcodeView: AnyObject, SnackDisplayable {
    func displayInitialData(viewModel: QRcodeModels.InitialData.ViewModel)
    func displayQRcode(viewModel: QRcodeModels.QRcode.ViewModel)
}

final class QRcodeViewController: UIViewController {
    // MARK: - Internal properties

    var presenter: QRcodePresenter?

    // MARK: - Private properties

    // MARK: - Views

    private lazy var qrView: QRView = {
        let view = QRView()
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.Styles.body
        label.textColor = Colors.Text.inverted.color
        label.isSkeletonable = false
        return label
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

extension QRcodeViewController {
    @objc
    fileprivate func onCloseTap() {
        presenter?.onCloseTap()
    }

    fileprivate func addSubviews() {
        view.addSubview(qrView)
        view.addSubview(descriptionLabel)
        view.addSubview(closeButton)
    }

    fileprivate func setupConstraints() {
        qrView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.inset)
            make.center.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(qrView.snp.bottom).offset(Constants.inset)
            make.left.right.equalToSuperview().inset(Constants.inset)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            make.width.greaterThanOrEqualTo(44)
            make.height.greaterThanOrEqualTo(44)
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.accentColor.color
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - MainView

extension QRcodeViewController: QRcodeView {
    func displayInitialData(viewModel: QRcodeModels.InitialData.ViewModel) {
        qrView.viewModel = viewModel.qrViewModel
        descriptionLabel.text = viewModel.caption
    }

    func displayQRcode(viewModel: QRcodeModels.QRcode.ViewModel) {
        qrView.viewModel = viewModel.qrViewModel
        descriptionLabel.text = viewModel.caption
    }
}

// MARK: - Constants

extension QRcodeViewController {
    fileprivate enum Constants {
        static let inset: CGFloat = 24.0
    }
}
