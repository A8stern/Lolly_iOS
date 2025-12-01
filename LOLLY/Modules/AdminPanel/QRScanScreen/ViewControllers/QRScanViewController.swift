//
//  QRScanViewController.swift
//  Brewsell
//
//  Created by Kovalev Gleb on 29.11.2025.
//

import AVFoundation
private import SnapKit
internal import UIKit

protocol QRScanView: AnyObject, SnackDisplayable { }

final class QRScanViewController: UIViewController {
    // MARK: - Internal Properties

    var presenter: QRScanPresenter?

    // MARK: - Private Properties

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isHandlingResult = false

    private let scanAreaView = UIView()
    private let hintLabel = UILabel()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Text.primary.color
        button.setImage(
            Assets.Controls.close.image.withRenderingMode(.alwaysTemplate),
            for: []
        )
        button.addActionHandler({ [weak self] in
            guard let self else { return }
            presenter?.onCloseTap()
        }, for: .touchUpInside)

        return button
    }()

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()

    private var metadataOutput: AVCaptureMetadataOutput?

    private let sessionQueue = DispatchQueue(label: "qrscan.capture.session.queue", qos: .userInitiated)

    private var overlayMaskLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupViews()
        configureCamera()

        presenter?.onViewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        updateOverlayMask()
        updateRectOfInterest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSessionIfPossible()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }
}

// MARK: - Setup

extension QRScanViewController {
    fileprivate func setupLayout() {
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(scanAreaView)
        scanAreaView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.scanAreaTop)
            make.left.equalToSuperview().offset(Constants.horizontalInset)
            make.right.equalToSuperview().inset(Constants.horizontalInset)
            make.height.equalTo(scanAreaView.snp.width)
        }

        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(scanAreaView.snp.bottom).offset(Constants.hintTopOffset)
            make.left.equalToSuperview().offset(Constants.horizontalInset)
            make.right.equalToSuperview().inset(Constants.horizontalInset)
        }

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.closeButtonTopInset)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Constants.closeButtonHorizontalInset)
            make.size.equalTo(Constants.closeButtonSize)
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = .black

        scanAreaView.backgroundColor = .clear
        scanAreaView.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        scanAreaView.layer.borderWidth = 2
        scanAreaView.layer.cornerRadius = 12
        scanAreaView.layer.masksToBounds = true

        hintLabel.text = L10n.Qr.Scan.label
        hintLabel.textColor = .white
        hintLabel.font = Fonts.TTTravels.demiBold.font(size: 15)
        hintLabel.numberOfLines = 2
        hintLabel.textAlignment = .center
    }
}

// MARK: - Camera Setup

extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    private func configureCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                DispatchQueue.main.async {
                    if granted {
                        self.setupCaptureSession()
                    } else {
                        self.showCameraDeniedSnack()
                    }
                }
            }

        case .denied, .restricted:
            showCameraDeniedSnack()

        @unknown default:
            showCameraDeniedSnack()
        }
    }

    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        guard let device = AVCaptureDevice.default(for: .video) else {
            showSnack(with: .error(text: "Камера недоступна"))
            captureSession.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                showSnack(with: .error(text: "Ошибка камеры"))
                captureSession.commitConfiguration()
                return
            }
        } catch {
            showSnack(with: .error(text: error.localizedDescription))
            captureSession.commitConfiguration()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            self.metadataOutput = metadataOutput
        } else {
            showSnack(with: .error(text: "Ошибка камеры"))
            captureSession.commitConfiguration()
            return
        }

        captureSession.commitConfiguration()

        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.bounds
        view.layer.insertSublayer(preview, at: 0)
        previewLayer = preview

        updateRectOfInterest()
    }

    private func startSessionIfPossible() {
        if Thread.isMainThread {
            self.isHandlingResult = false
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isHandlingResult = false
            }
        }
        sessionQueue.async { [weak self] in
            guard let self else { return }
            guard !self.captureSession.inputs.isEmpty, !self.captureSession.outputs.isEmpty else { return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }

    private func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }

    private func showCameraDeniedSnack() {
        presenter?.openCameraPermissionScreen()
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard isHandlingResult == false else { return }

        let filteredObjects: [AVMetadataObject] = metadataObjects.compactMap { meta in
            guard let previewLayer else { return nil }
            guard let transformed = previewLayer.transformedMetadataObject(for: meta) else { return nil }

            let scanRectInView = scanAreaView.convert(scanAreaView.bounds, to: view)
            let scanRectInLayer = previewLayer.convert(scanRectInView, from: view.layer)

            let metadataFrame = transformed.bounds
            return scanRectInLayer.contains(metadataFrame) ? meta : nil
        }

        guard let object = filteredObjects.first
            as? AVMetadataMachineReadableCodeObject,
                object.type == .qr,
                let stringValue = object.stringValue,
                stringValue.isEmpty == false
        else {
            return
        }

        isHandlingResult = true
        stopSession()

        presenter?.onQRCodeScanned(stringValue)
    }
}

extension QRScanViewController {
    private func updateOverlayMask() {
        let fullPath = UIBezierPath(rect: overlayView.bounds)
        let scanRect = overlayView.convert(scanAreaView.bounds, from: scanAreaView)
        let holePath = UIBezierPath(roundedRect: scanRect, cornerRadius: scanAreaView.layer.cornerRadius)
        fullPath.append(holePath)
        fullPath.usesEvenOddFillRule = true

        let maskLayer: CAShapeLayer
        if let existing = overlayMaskLayer {
            maskLayer = existing
            maskLayer.path = fullPath.cgPath
        } else {
            maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd
            maskLayer.path = fullPath.cgPath
            overlayView.layer.addSublayer(maskLayer)
            overlayMaskLayer = maskLayer
        }

        maskLayer.fillColor = Colors.accentColor.color.withAlphaComponent(0.5).cgColor

        overlayView.backgroundColor = .clear
    }

    private func updateRectOfInterest() {
        guard let previewLayer,
            let metadataOutput
        else { return }

        let layerRect = view.layer.convert(scanAreaView.frame, from: scanAreaView.superview?.layer)
        let normalized = previewLayer.metadataOutputRectConverted(fromLayerRect: layerRect)
        metadataOutput.rectOfInterest = normalized
    }
}

extension QRScanViewController: QRScanView { }

extension QRScanViewController {
    fileprivate enum Constants {
        static let closeButtonSize: CGSize = .init(width: 44, height: 44)
        static let closeButtonHorizontalInset: CGFloat = 16.0
        static let closeButtonTopInset: CGFloat = 8.0

        static let scanAreaTop: CGFloat = 200.0
        static let horizontalInset: CGFloat = 16.0
        static let hintTopOffset: CGFloat = 24.0
    }
}
