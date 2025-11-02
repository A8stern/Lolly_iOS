//
//  BlurView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 02.11.2025.
//

import UIKit

public final class BlurView: UIVisualEffectView {

    init() {
        let effect: UIVisualEffect
        if #available(iOS 26.0, *) {
            effect = UIGlassEffect(style: .regular)
        } else {
            effect = UIBlurEffect(style: .systemMaterial)
        }
        super.init(effect: effect)

        setupUI ()
    }

    required init?(coder: NSCoder) {
        let effect: UIVisualEffect
        if #available(iOS 26.0, *) {
            effect = UIGlassEffect(style: .regular)
        } else {
            effect = UIBlurEffect(style: .systemMaterial)
        }
        super.init(effect: effect)

        setupUI()
    }

    private func setupUI() {
        layer.masksToBounds = true
    }
}
