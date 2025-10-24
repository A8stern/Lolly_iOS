//
//  HapticManager.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 24.10.2025.
//

import CoreHaptics
import UIKit.UIImpactFeedbackGenerator
import UIKit.UINotificationFeedbackGenerator
import UIKit.UISelectionFeedbackGenerator

public final class HapticManager {
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]

    private var notificationGenerator = UINotificationFeedbackGenerator()
    private var selectionGenerator = UISelectionFeedbackGenerator()

    public init() {
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }

    private func createImpactGeneratorIfNeeded(
        for style: UIImpactFeedbackGenerator.FeedbackStyle
    ) -> UIImpactFeedbackGenerator {
        guard let generator = impactGenerators[style] else {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            impactGenerators[style] = generator
            return generator
        }

        return generator
    }

    private func playSensoryFeedback(style: HapticSensoryFeedbackStyle) {
        switch style {
            case .notification(let weight):
                let type = weight.asFeedbackType()
                notificationGenerator.prepare()
                notificationGenerator.notificationOccurred(type)

            case .impact(let weight):
                let style = weight.asFeedbackStyle()
                let impactGenerator = createImpactGeneratorIfNeeded(for: style)
                impactGenerator.prepare()
                impactGenerator.impactOccurred()

            case .selection:
                selectionGenerator.prepare()
                selectionGenerator.selectionChanged()
        }
    }
}

// MARK: - HapticManagerInterface

extension HapticManager: HapticManagerInterface {
    public var isHapticAvailable: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    public func play(
        type: HapticType
    ) {
        guard isHapticAvailable else { return }

        switch type {
            case .sensoryFeedback(let style):
                playSensoryFeedback(style: style)
        }
    }
}

// MARK: - HapticNotificationWeight

fileprivate extension HapticNotificationWeight {
    func asFeedbackType() -> UINotificationFeedbackGenerator.FeedbackType {
        switch self {
            case .success: .success
            case .warning: .warning
            case .error: .error
        }
    }
}

// MARK: - HapticImpactWeight

fileprivate extension HapticImpactWeight {
    func asFeedbackStyle() -> UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
            case .light: .light
            case .medium: .medium
            case .heavy: .heavy
            case .rigid: .rigid
            case .soft: .soft
        }
    }
}
