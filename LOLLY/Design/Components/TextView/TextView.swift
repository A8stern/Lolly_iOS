//
//  TextView.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

private import SnapKit
import UIKit

@objc
public protocol TextViewDelegate: AnyObject {
    func textView(
        _ textView: TextView,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool

    @objc
    optional func textViewDidBeginEditing(_ textView: TextView)

    @objc
    optional func textViewDidEndEditing(_ textView: TextView)

    @objc
    optional func textViewDidChange(_ textView: TextView)
}

public class TextView: UIView {
    // MARK: - Public properties

    public weak var delegate: TextViewDelegate?

    public var title: String = .init() {
        didSet {
            updateTitle()
        }
    }

    public var state: TextViewState = .empty {
        didSet {
            updateState()
        }
    }

    public var text: String {
        get {
            textView.text
        }
        set {
            textView.text = newValue
            updateTitleVisibilityIfNeeded()
            updateTextViewHeight()
            updateMaxLengthLabel()
        }
    }

    public var maxLength: Int = 0 {
        didSet {
            updateMaxLengthLabel()
        }
    }

    public var keyboardType: UIKeyboardType = .default {
        didSet {
            textView.keyboardType = keyboardType
        }
    }

    public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    public var shouldDisplayTitleWhenNonEmpty: Bool = false

    public var maxLines: Int = 0 {
        didSet {
            updateTextViewHeight()
        }
    }

    public var minHeight: CGFloat = Constants.minHeight {
        didSet {
            updateTextViewHeight()
        }
    }

    public var maxHeight: CGFloat = Constants.maxHeight {
        didSet {
            updateTextViewHeight()
        }
    }

    // MARK: - Private properties

    private var textViewHeightConstraint: Constraint?
    private var maxLengthTopConstraint: Constraint?
    private var isEmpty: Bool { textView.text.isEmpty }
    private var isEditing: Bool = false
    private var isExceedingMaxLength: Bool {
        maxLength > 0 && text.count > maxLength
    }

    // MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = Fonts.Styles.caption
        return label
    }()

    private lazy var maxLengthLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Colors.Text.secondary.color
        label.font = Fonts.Styles.caption
        label.textAlignment = .right
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        textView.textColor = Colors.Text.primary.color
        textView.font = Fonts.Styles.title2
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        return textView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Colors.Text.secondary.color
        label.font = Fonts.Styles.title2
        label.isHidden = true
        return label
    }()

    private lazy var viewContainerView: UIView = {
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
        textView.becomeFirstResponder()
    }
}

// MARK: - Private methods

extension TextView {
    fileprivate func configure() {
        backgroundColor = .clear
        viewContainerView.backgroundColor = Colors.Custom.textFieldBackground.color
        textView.delegate = self
        titleLabel.isHidden = true
        maxLengthLabel.isHidden = true
        placeholderLabel.isHidden = true
        updateState(animated: false)
    }

    fileprivate func updateTitle() {
        titleLabel.text = title
        updatePlaceholder()
    }

    fileprivate func updateTitleVisibilityIfNeeded() {
        guard shouldDisplayTitleWhenNonEmpty, titleLabel.isHidden, isEmpty == false else {
            return
        }

        titleLabel.isHidden = false
    }

    fileprivate func updatePlaceholder() {
        let placeholderText = placeholder ?? title
        placeholderLabel.text = placeholderText
        placeholderLabel.isHidden = !isEmpty || isEditing
    }

    fileprivate func updateMaxLengthLabel() {
        let shouldShowMaxLength = maxLength > 0
        maxLengthLabel.isHidden = !shouldShowMaxLength
        maxLengthTopConstraint?.update(offset: shouldShowMaxLength ? Constants.maxLengthTopOffset : 0)

        if shouldShowMaxLength {
            let currentLength = text.count
            maxLengthLabel.text = "\(currentLength)/\(maxLength)"

            if isExceedingMaxLength, state != .invalid {
                state = .invalid
            } else if !isExceedingMaxLength, state == .invalid {
                state = .empty
            }
        }
    }

    fileprivate func addSubviews() {
        addSubview(maxLengthLabel)
        addSubview(viewContainerView)
        viewContainerView.addSubview(textView)
        viewContainerView.addSubview(titleLabel)
        viewContainerView.addSubview(placeholderLabel)
    }

    fileprivate func setupConstraints() {
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(minHeight)
        }

        viewContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(minHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalInset)
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.textViewTopOffset)
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.bottom.equalToSuperview().inset(Constants.verticalInset)
            textViewHeightConstraint =
                make.height.greaterThanOrEqualTo(Constants.minTextViewHeight).constraint
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(Constants.horizontalInset)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        maxLengthLabel.snp.makeConstraints { make in
            maxLengthTopConstraint =
                make.top.equalTo(viewContainerView.snp.bottom)
                .offset(maxLength > 0 ? Constants.maxLengthTopOffset : 0).constraint
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    fileprivate func updateState(animated: Bool = true) {
        UIView.animate(withDuration: animated ? Constants.animationDuration : 0) { [weak self] in
            guard let self else { return }
            textView.tintColor = state.foregroundColor
            textView.textColor = state.foregroundColor
            maxLengthLabel.textColor = state.maxLengthColor
            titleLabel.textColor = state.titleColor
            placeholderLabel.textColor = state.titleColor
            updateBorderState()
            updatePlaceholder()
        }
        textView.isUserInteractionEnabled = state != .disabled
    }

    fileprivate func updateBorderState() {
        guard isEditing == true || state == .invalid else {
            viewContainerView.layer.borderColor = UIColor.clear.cgColor
            return
        }
        viewContainerView.layer.borderColor = state.borderColor.cgColor
    }

    fileprivate func updateTextViewHeight() {
        let fixedWidth =
            textView.frame.width - textView.textContainerInset.left - textView.textContainerInset.right
        let sizeThatFits = textView.sizeThatFits(
            CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        )

        var newHeight = max(sizeThatFits.height, Constants.minTextViewHeight)

        if maxLines > 0 {
            let maxHeight = textView.font?.lineHeight ?? Constants.minTextViewHeight * CGFloat(maxLines)
            let calculatedMaxHeight =
                maxHeight * CGFloat(maxLines) + textView.textContainerInset.top
                    + textView
                    .textContainerInset.bottom
            newHeight = min(newHeight, calculatedMaxHeight)
        }

        newHeight = min(
            newHeight, maxHeight - Constants.verticalInset * 2 - Constants.textViewTopOffset
        )

        textViewHeightConstraint?.update(offset: newHeight)

        viewContainerView.snp.updateConstraints { make in
            make.height.greaterThanOrEqualTo(
                newHeight + Constants.verticalInset * 2 + Constants.textViewTopOffset
            )
        }

        textView.isScrollEnabled =
            newHeight >= maxHeight - Constants.verticalInset * 2 - Constants.textViewTopOffset

        UIView.animate(withDuration: Constants.animationDuration) {
            self.layoutIfNeeded()
        }
    }

    // MARK: - Focusing

    fileprivate func animateFocus() {
        isEditing = true
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            titleLabel.isHidden = false
            placeholderLabel.isHidden = true
            updateBorderState()
            layoutIfNeeded()
        }
    }

    fileprivate func animateUnfocus() {
        isEditing = false
        let isTitleHidden = isEmpty == true && !shouldDisplayTitleWhenNonEmpty
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            titleLabel.isHidden = isTitleHidden
            placeholderLabel.isHidden = !isEmpty
            updateBorderState()
            layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate

extension TextView: UITextViewDelegate {
    public func textViewDidBeginEditing(_: UITextView) {
        animateFocus()
        delegate?.textViewDidBeginEditing?(self)
    }

    public func textViewDidEndEditing(_: UITextView) {
        animateUnfocus()
        delegate?.textViewDidEndEditing?(self)
    }

    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if maxLength > 0 {
            let currentText = textView.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: text)

            if newText.count > maxLength {
                if text.count > 1 {
                    let remainingLength = maxLength - currentText.count + range.length
                    if remainingLength > 0 {
                        let allowedText = String(text.prefix(remainingLength))
                        textView.text = (currentText as NSString).replacingCharacters(
                            in: range, with: allowedText
                        )
                        updateMaxLengthLabel()
                        updateTextViewHeight()
                        delegate?.textViewDidChange?(self)
                    }
                }
                return false
            }
        }

        return delegate?.textView(
            self,
            shouldChangeCharactersIn: range,
            replacementString: text
        ) ?? true
    }

    public func textViewDidChange(_: UITextView) {
        updatePlaceholder()
        updateTextViewHeight()
        updateMaxLengthLabel()
        delegate?.textViewDidChange?(self)
    }
}

// MARK: - Backward compatibility

extension TextView {
    public var beginningOfDocument: UITextPosition {
        textView.beginningOfDocument
    }

    public var endOfDocument: UITextPosition {
        textView.endOfDocument
    }

    public func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition)
        -> UITextRange?
    {
        return textView.textRange(from: fromPosition, to: toPosition)
    }

    public func range(from textRange: UITextRange) -> Range<String.Index>? {
        return textView.range(from: textRange)
    }
}

// MARK: - Constants

extension TextView {
    fileprivate enum Constants {
        static let minHeight: CGFloat = 68.0
        static let maxHeight: CGFloat = 200.0
        static let minTextViewHeight: CGFloat = 20.0
        static let borderWidth: CGFloat = 1.5
        static let buttonSize: CGFloat = 24.0
        static let focusOffset: CGFloat = 10.5
        static let cornerRadius: CGFloat = 16.0
        static let verticalInset: CGFloat = 12.0
        static let horizontalInset: CGFloat = 16.0
        static let maxLengthTopOffset: CGFloat = 4.0
        static let textViewTopOffset: CGFloat = 4.0
        static let placeholderOffset: CGFloat = 8.0
        static let animationDuration: CGFloat = 0
    }
}

extension TextViewState {
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

    fileprivate var maxLengthColor: UIColor {
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
