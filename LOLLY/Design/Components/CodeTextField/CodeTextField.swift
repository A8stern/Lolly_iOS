//
//  CodeTextField.swift
//  LOLLY
//
//  Created by Kovalev Gleb on 30.10.2025.
//

import UIKit

// MARK: - Основной контрол
final class CodeTextField: UIControl, UITextFieldDelegate {
    static let defaultFont: UIFont = Fonts.TTTravels.medium.font(size: 30)
    static let defaultFillColor: UIColor = UIColor(asset: Colors.Custom.textFieldBackground) ?? .systemGray6
    static let defaultInactiveBorderColor: UIColor = UIColor(asset: Colors.Custom.textFieldBackground) ?? .systemGray6
    static let defaultActiveBorderColor: UIColor = UIColor(asset: Colors.Constants.black) ?? .black
    static let defaultTextColor: UIColor = UIColor(asset: Colors.Text.primary) ?? .label

    var length: Int = 4 {
        didSet {
            rebuild()
            invalidateIntrinsicContentSize()
        }
    }
    var spacing: CGFloat = 12 {
        didSet { stack.spacing = spacing }
    }
    var boxSize: CGSize = .init(width: 56, height: 56) {
        didSet {
            updateBoxSizes()
            updateStackHeight()
            invalidateIntrinsicContentSize()
        }
    }
    var cornerRadius: CGFloat = 12 {
        didSet { cells.forEach { $0.cornerRadius = cornerRadius } }
    }
    var font: UIFont = CodeTextField.defaultFont {
        didSet { cells.forEach { $0.font = font } }
    }
    var activeBorderColor: UIColor = CodeTextField.defaultActiveBorderColor {
        didSet { cells.forEach { $0.activeBorderColor = activeBorderColor } }
    }
    var inactiveBorderColor: UIColor = CodeTextField.defaultInactiveBorderColor {
        didSet { cells.forEach { $0.inactiveBorderColor = inactiveBorderColor } }
    }
    var fillColor: UIColor = CodeTextField.defaultFillColor {
        didSet { cells.forEach { $0.fillColor = fillColor } }
    }
    var textColor: UIColor = CodeTextField.defaultTextColor {
        didSet { cells.forEach { $0.label.textColor = textColor } }
    }

    /// Текущее значение кода
    private(set) var code: String = "" {
        didSet {
            sendActions(for: .editingChanged)
            onCodeChanged?(code)
            if code.count == length {
                sendActions(for: .editingDidEndOnExit)
                onCodeFilled?(code)
            }
        }
    }

    /// Коллбэки при изменении и завершении ввода
    var onCodeChanged: ((String) -> Void)?
    var onCodeFilled: ((String) -> Void)?

    // UI
    private let stack = UIStackView()
    private var cells: [DigitCellView] = []
    private var sizeConstraints: [NSLayoutConstraint] = []
    private var stackHeightConstraint: NSLayoutConstraint?

    // Скрытое поле ввода
    private lazy var hiddenField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.delegate = self
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.isHidden = true
        return textField
    }()

    override var intrinsicContentSize: CGSize {
        let totalSpacing = spacing * CGFloat(max(0, length - 1))
        let width = CGFloat(length) * boxSize.width + totalSpacing
        return CGSize(width: width, height: boxSize.height)
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyDefaultStyle()
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyDefaultStyle()
        setup()
    }

    /// Применяет ваши кастомные стили по умолчанию
    private func applyDefaultStyle() {
        font = CodeTextField.defaultFont
        fillColor = CodeTextField.defaultFillColor
        inactiveBorderColor = CodeTextField.defaultInactiveBorderColor
        activeBorderColor = CodeTextField.defaultActiveBorderColor
        textColor = CodeTextField.defaultTextColor
    }

    private func setup() {
        // Стек
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = spacing

        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        stackHeightConstraint = stack.heightAnchor.constraint(equalToConstant: boxSize.height)
        stackHeightConstraint?.priority = .required
        stackHeightConstraint?.isActive = true

        stack.setContentHuggingPriority(.required, for: .horizontal)
        stack.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(hiddenField)

        let tap = UITapGestureRecognizer(target: self, action: #selector(focus))
        addGestureRecognizer(tap)

        isAccessibilityElement = false
        accessibilityElements = cells

        rebuild()
    }

    private func rebuild() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        cells.removeAll()
        sizeConstraints.forEach { $0.isActive = false }
        sizeConstraints.removeAll()

        for index in 0..<length {
            let cell = DigitCellView()
            cell.cornerRadius = cornerRadius
            cell.font = font
            cell.activeBorderColor = activeBorderColor
            cell.inactiveBorderColor = inactiveBorderColor
            cell.fillColor = fillColor
            cell.label.textColor = textColor
            cell.isActive = (index == 0)

            cell.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(cell)

            let width = cell.widthAnchor.constraint(equalToConstant: boxSize.width)
            NSLayoutConstraint.activate([width])
            sizeConstraints.append(width)

            cells.append(cell)
        }
        updateUI()
    }

    private func updateStackHeight() {
        stackHeightConstraint?.constant = boxSize.height
    }

    private func updateBoxSizes() {
        for idx in 0..<sizeConstraints.count {
            sizeConstraints[idx].constant = boxSize.width
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Focus
    @objc
    private func focus() {
        _ = becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool { true }
    override func becomeFirstResponder() -> Bool {
        hiddenField.text = code
        let okay = hiddenField.becomeFirstResponder()
        updateActiveCell()
        return okay
    }

    override func resignFirstResponder() -> Bool {
        let okay = hiddenField.resignFirstResponder()
        updateActiveCell()
        return okay
    }

    // MARK: - API
    func setCode(_ new: String) {
        let digits = new.filter(\.isNumber)
        code = String(digits.prefix(length))
        hiddenField.text = code
        updateUI()
    }

    func clear() {
        code = ""
        hiddenField.text = ""
        updateUI()
    }

    /// Лёгкая анимация ошибки
    func shake() {
        let anim = CABasicAnimation(keyPath: "position.x")
        anim.duration = 0.05
        anim.repeatCount = 4
        anim.autoreverses = true
        anim.fromValue = layer.position.x - 6
        anim.toValue = layer.position.x + 6
        layer.add(anim, forKey: "shake")
    }

    // MARK: - UI sync
    private func updateUI() {
        for (index, cell) in cells.enumerated() {
            let character: Character? = index < code.count ? Array(code)[index] : nil
            cell.label.text = character.map { String($0) } ?? ""
        }
        if hiddenField.text != code {
            hiddenField.text = code
        }
        invalidateIntrinsicContentSize()
        updateActiveCell()
    }

    private func updateActiveCell() {
        let filledCount = min(code.count, length)
        let caretIndex = min(filledCount, length - 1)

        for (index, cell) in cells.enumerated() {
            let isFilledCell = index < filledCount
            let isCaretCell = isFirstResponder && (index == caretIndex) && (filledCount < length)
            cell.isActive = isFilledCell || isCaretCell
        }
    }

    // MARK: - UITextFieldDelegate (фильтрация ввода)
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let current = textField.text ?? ""

        guard let textRange = Range(range, in: current) else {
            return false
        }

        var prospective = current.replacingCharacters(in: textRange, with: string)
        prospective = prospective.filter(\.isNumber)

        if prospective.count > length {
            prospective = String(prospective.prefix(length))
        }

        textField.text = prospective
        code = prospective
        updateUI()

        return false
    }
}
