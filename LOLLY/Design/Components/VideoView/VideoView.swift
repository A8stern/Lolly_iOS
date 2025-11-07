//
//  VideoView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

import AVFoundation
private import SnapKit
import UIKit

public final class VideoView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    public var viewModel: VideoViewModel? {
        didSet {
            setupPlayer()
        }
    }

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        observeAppLifecycle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .black
        observeAppLifecycle()
    }

    // MARK: - Setup Player

    private func setupPlayer() {
        guard let viewModel, let url = viewModel.fileURL else {
            print("❌ Video file not found in bundle")
            return
        }

        player?.pause()
        playerLayer?.removeFromSuperlayer()

        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        player.isMuted = viewModel.isMuted

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        self.player = player
        self.playerLayer = playerLayer

        if viewModel.shouldLoop {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(loopVideo),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
        }

        player.play()
    }

    @objc
    private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    // MARK: - Lifecycle handling

    private func observeAppLifecycle() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc
    private func appWillResignActive() {
        player?.pause()
    }

    @objc
    private func appDidBecomeActive() {
        player?.play()
    }

    // MARK: - Manual controls

    public func play() {
        player?.play()
    }

    public func pause() {
        player?.pause()
    }

    // MARK: - Cleanup

    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
}
