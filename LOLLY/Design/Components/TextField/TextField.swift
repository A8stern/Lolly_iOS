//
//  TextField.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

private import SnapKit
import UIKit

@objc
public protocol TextFieldDelegate: AnyObject {
    func textField(
        _ textField: TextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool

    @objc
    optional func textFieldDidBeginEditing(_ textField: TextField)

    @objc
    optional func textFieldDidEndEditing(_ textField: TextField)
}

public class TextField: UIView {
    // MARK: - Public properties

    public weak var delegate: TextFieldDelegate?

    public var title: String = .init() {
        didSet {
            updateTitle()
        }
    }

    public var state: TextFieldState = .empty {
        didSet {
            updateState()
        }
    }

    public var text: String {
        get {
            textField.text ?? ""
        }
        set {
            textField.text = newValue
            updateTitleVisibilityIfNeeded()
        }
    }

    /// Подзаголовок под полем ввода
    public var caption: String = .init() {
        didSet {
            updateCaption()
        }
    }

    public var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    /// Отображать заголовок при первом появлении, если текст не пустой
    public var shouldDisplayTitleWhenNonEmpty: Bool = false

    // MARK: - Private properties

    // swiftlint:disable implicitly_unwrapped_optional
    private var fieldTopConstraint: Constraint?
    private var fieldBottomConstraint: Constraint?
    private var captionTopConstraint: Constraint?
    // swiftlint:enable implicitly_unwrapped_optional

    private var isEmpty: Bool { (textField.text ?? String()).isEmpty }
    private var isEditing: Bool = false

    // MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Fonts.TTTravels.medium.font(size: 13)
        return label
    }()

    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Colors.Text.secondary.color
        label.font = Fonts.TTTravels.medium.font(size: 13)

        return label
    }()

    private lazy var textField: UITextField = {
        let field = UITextField()
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        field.textColor = Colors.Text.primary.color
        field.font = Fonts.TTTravels.medium.font(size: 18)
        field.addTarget(self, action: #selector(edittingChanged), for: .editingChanged)

        return field
    }()

    private lazy var fieldContainerView: UIView = {
        let container = UIView()
        container.layer.borderWidth = Constants.borderWidth
        container.layer.cornerRadius = Constants.cornerRadius
        return container
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setupConstraints()
        configure()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateBorderState()
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        textField.becomeFirstResponder()
    }
}

// MARK: - Private methods

extension TextField {
    fileprivate func configure() {
        backgroundColor = .clear
        fieldContainerView.backgroundColor = Colors.Custom.textFieldBackground.color
        textField.delegate = self
        titleLabel.isHidden = true
        captionLabel.isHidden = true
        updateState(animated: false)
    }

    fileprivate func updateTitle() {
        titleLabel.text = title
        updatePlaceholder()
    }

    fileprivate func updateTitleVisibilityIfNeeded() {
        guard shouldDisplayTitleWhenNonEmpty,
            titleLabel.isHidden,
            isEmpty == false
        else {
            return
        }

        titleLabel.isHidden = false
        fieldTopConstraint?.update(offset: Constants.verticalInset + Constants.focusOffset)
        fieldBottomConstraint?.update(inset: Constants.verticalInset - Constants.focusOffset)
    }

    fileprivate func updatePlaceholder() {
        // Плейсхолдер может быть как из заголовка, тк и задаваться через отдельное свойство
        let placeholder = isEditing ?
            placeholder ?? title :
            title
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: state.titleColor]
        )
    }

    fileprivate func updateCaption() {
        captionLabel.isHidden = caption.isEmpty
        captionTopConstraint?.update(offset: caption.isEmpty ? 0 : Constants.captionTopOffset)
        captionLabel.text = caption
    }

    fileprivate func addSubviews() {
        addSubview(captionLabel)
        addSubview(fieldContainerView)
        fieldContainerView.addSubview(textField)
        fieldContainerView.addSubview(titleLabel)
    }

    fileprivate func setupConstraints() {
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(Constants.height)
        }

        fieldContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.height)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
        }

        textField.snp.makeConstraints { make in
            fieldTopConstraint = make.top.equalToSuperview().offset(Constants.verticalInset).constraint
            fieldBottomConstraint = make.bottom.equalToSuperview().inset(Constants.verticalInset).constraint
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        captionLabel.snp.makeConstraints { make in
            captionTopConstraint = make.top.equalTo(fieldContainerView.snp.bottom)
                .offset(caption.isEmpty ? 0 : Constants.captionTopOffset).constraint
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    fileprivate func updateState(animated: Bool = true) {
        UIView.animate(withDuration: animated ? Constants.animationDuration : 0) { [weak self] in
            guard let self else { return }
            textField.tintColor = state.foregroundColor
            textField.textColor = state.foregroundColor
            captionLabel.textColor = state.captionColor
            titleLabel.textColor = state.titleColor
            updateBorderState()
            updatePlaceholder()
        }
        textField.isUserInteractionEnabled = state != .disabled
    }

    fileprivate func updateBorderState() {
        guard isEditing == true || state == .invalid else {
            fieldContainerView.layer.borderColor = UIColor.clear.cgColor
            return
        }
        // всегда показываем рамку для сфокусированного состояния и при невалидном значении
        fieldContainerView.layer.borderColor = state.borderColor.cgColor
    }

    // MARK: - Focusing

    fileprivate func animateFocus() {
        isEditing = true
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            titleLabel.isHidden = false
            updatePlaceholder()
            updateBorderState()
            layoutIfNeeded()
        }
        fieldTopConstraint?.update(offset: Constants.verticalInset + Constants.focusOffset)
        fieldBottomConstraint?.update(inset: Constants.verticalInset - Constants.focusOffset)
    }

    fileprivate func animateUnfocus() {
        isEditing = false
        let isTitleHidden = isEmpty == true
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            titleLabel.isHidden = isTitleHidden
            textField.placeholder = title
            updateBorderState()
            layoutIfNeeded()
        }
        if isTitleHidden {
            fieldTopConstraint?.update(offset: Constants.verticalInset)
            fieldBottomConstraint?.update(inset: Constants.verticalInset)
        }
    }
}

// MARK: - UITextFieldDelegate

extension TextField: UITextFieldDelegate {
    @objc
    func edittingChanged() {
        updateState()
    }

    public func textFieldDidBeginEditing(_: UITextField) {
        animateFocus()
        delegate?.textFieldDidBeginEditing?(self)
    }

    public func textFieldDidEndEditing(_: UITextField) {
        animateUnfocus()
        delegate?.textFieldDidEndEditing?(self)
    }

    public func textField(
        _: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        delegate?.textField(
            self,
            shouldChangeCharactersIn: range,
            replacementString: string
        ) ?? true
    }

    public func textFieldShouldReturn(_: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}

// MARK: - Backward compatibility

extension TextField {
    public var beginningOfDocument: UITextPosition {
        textField.beginningOfDocument
    }

    public var endOfDocument: UITextPosition {
        textField.endOfDocument
    }

    public func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        return textField.textRange(from: fromPosition, to: toPosition)
    }

    public func range(from textRange: UITextRange) -> Range<String.Index>? {
        return textField.range(from: textRange)
    }
}

// MARK: - Constants

extension TextField {
    fileprivate enum Constants {
        static let height: CGFloat = 68.0
        static let borderWidth: CGFloat = 1.5
        static let buttonSize: CGFloat = 24.0
        static let focusOffset: CGFloat = 10.5
        static let cornerRadius: CGFloat = 16.0
        static let verticalInset: CGFloat = 22.5
        static let horizontalInset: CGFloat = 24.0
        static let captionTopOffset: CGFloat = 4.0
        static let animationDuration: CGFloat = 0.2
    }
}

extension TextFieldState {
    fileprivate var titleColor: UIColor {
        switch self {
            case .correct, .empty, .invalid:
                return Colors.Text.secondary.color

            case .disabled:
                return Colors.Controls.disabled.color
        }
    }

    fileprivate var borderColor: UIColor {
        switch self {
            case .correct:
                return Colors.Text.primary.color

            case .empty:
                return Colors.Text.primary.color

            case .invalid:
                return .red

            case .disabled:
                return Colors.Controls.disabled.color
        }
    }

    fileprivate var foregroundColor: UIColor {
        switch self {
            case .correct:
                return Colors.Text.primary.color

            case .empty:
                return Colors.Text.primary.color

            case .invalid:
                return .red

            case .disabled:
                return Colors.Controls.disabled.color
        }
    }

    fileprivate var captionColor: UIColor {
        switch self {
            case .correct:
                return .green

            case .empty:
                return Colors.Text.secondary.color

            case .invalid:
                return .red

            case .disabled:
                return Colors.Controls.disabled.color
        }
    }
}

extension UITextInput {
    fileprivate func range(from textRange: UITextRange) -> Range<String.Index>? {
        guard let text = text(in: textRange) else { return nil }
        let location = offset(from: beginningOfDocument, to: textRange.start)
        let length = offset(from: textRange.start, to: textRange.end)
        let range = NSRange(location: location, length: length)
        return Range(range, in: text)
    }
}
