//
//  HapticSensoryFeedbackStyle.swift
//
//
//  Created by Kirill Prokofyev on 28.08.2025.
//

/*
    Описание откликов
    [Playing haptics](https://developer.apple.com/design/human-interface-guidelines/playing-haptics)
*/
public enum HapticSensoryFeedbackStyle {
    /// Notification haptics provide feedback about the outcome of a task or action,
    /// such as depositing a check or unlocking a vehicle.
    case notification(weight: HapticNotificationWeight)

    /// Impact haptics provide a physical metaphor you can use to complement a visual experience.
    /// For example, people might feel a tap when a view snaps into place
    /// or a thud when two heavy objects collide.
    case impact(weight: HapticImpactWeight)

    /// Indicates that a UI element’s values are changing.
    case selection
}
