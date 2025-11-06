//
//  Keyboard+LayoutGuide.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

import UIKit

internal class Keyboard {
    static let shared = Keyboard()
    var currentHeight: CGFloat = 0
}

extension UIView {
    private enum Identifiers {
        static var usingSafeArea = "KeyboardLayoutGuideUsingSafeArea"
        static var notUsingSafeArea = "KeyboardLayoutGuide"
    }

    /// Layout guid'ы, предоставляющие inset'ы для клавиатуры.
    /// Используйте layout guide’s top anchor для создания constraints, прикрепляемых к верхней (top) части клавиатуры
    /// или нижней части safe area.
    public var keyboardLayoutGuideWithSafeArea: UILayoutGuide {
        getOrCreateKeyboardLayoutGuide(identifier: Identifiers.usingSafeArea, usesSafeArea: true)
    }

    public var keyboardLayoutGuideNoSafeArea: UILayoutGuide {
        getOrCreateKeyboardLayoutGuide(identifier: Identifiers.notUsingSafeArea, usesSafeArea: false)
    }

    private func getOrCreateKeyboardLayoutGuide(identifier: String, usesSafeArea: Bool) -> UILayoutGuide {
        if let existing = layoutGuides.first(where: { $0.identifier == identifier }) {
            return existing
        }
        let new = KeyboardLayoutGuide()
        new.usesSafeArea = usesSafeArea
        new.identifier = identifier
        addLayoutGuide(new)
        new.setUp()
        return new
    }
}

open class KeyboardLayoutGuide: UILayoutGuide {
    public var usesSafeArea = true {
        didSet {
            updateBottomAnchor()
        }
    }

    private var bottomConstraint: NSLayoutConstraint?

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        super.init()

        notificationCenter.addObserver(
            self,
            selector: #selector(adjustKeyboard(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(adjustKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    internal func setUp() {
        guard let view = owningView else { return }
        NSLayoutConstraint.activate(
            [
                heightAnchor.constraint(equalToConstant: Keyboard.shared.currentHeight),
                leftAnchor.constraint(equalTo: view.leftAnchor),
                rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
        )
        updateBottomAnchor()
    }

    func updateBottomAnchor() {
        if let bottomConstraint = bottomConstraint {
            bottomConstraint.isActive = false
        }

        guard let view = owningView else { return }

        let viewBottomAnchor: NSLayoutYAxisAnchor
        if usesSafeArea {
            viewBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            viewBottomAnchor = view.bottomAnchor
        }

        bottomConstraint = bottomAnchor.constraint(equalTo: viewBottomAnchor)
        bottomConstraint?.isActive = true
    }

    @objc
    private func adjustKeyboard(_ note: Notification) {
        if var height = note.keyboardHeight, let duration = note.animationDuration {
            if usesSafeArea, height > 0, let bottom = owningView?.safeAreaInsets.bottom {
                height -= bottom
            }
            heightConstraint?.constant = height
            if duration > 0.0 {
                animate(note)
            }
            Keyboard.shared.currentHeight = height
        }
    }

    private func animate(_ note: Notification) {
        if
            let owningView = self.owningView,
            isVisible(view: owningView)
        {
        self.owningView?.layoutIfNeeded()
        } else {
            UIView.performWithoutAnimation {
                self.owningView?.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Helpers

extension UILayoutGuide {
    internal var heightConstraint: NSLayoutConstraint? {
        return owningView?.constraints.first {
            $0.firstItem as? UILayoutGuide == self && $0.firstAttribute == .height
        }
    }
}

extension Notification {
    var keyboardHeight: CGFloat? {
        guard let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }

        if name == UIResponder.keyboardWillHideNotification {
            return 0.0
        } else {
            let keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }

            let screenHeight = keyWindow?.bounds.height ?? UIScreen.main.bounds.height
            return screenHeight - keyboardFrame.cgRectValue.minY
        }
    }

    var animationDuration: CGFloat? {
        return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat
    }
}

/// Позволяет определить, находится ли uiview's frame в пределах bounds superview (вплоть до корневого view).
/// Одним из практических вариантов использования является определение того, является ли child view
/// (по крайней мере частично) видимым в scrollview.
func isVisible(view: UIView) -> Bool {
    func isVisible(view: UIView, inView: UIView?) -> Bool {
        guard let inView = inView else { return true }
        let viewFrame = inView.convert(view.bounds, from: view)
        if viewFrame.intersects(inView.bounds) {
            return isVisible(view: view, inView: inView.superview)
        }
        return false
    }
    return isVisible(view: view, inView: view.superview)
}
