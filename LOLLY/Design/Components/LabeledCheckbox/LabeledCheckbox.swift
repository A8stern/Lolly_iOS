//
//  LabeledCheckbox.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 06.11.2025.
//

import UIKit

public enum CheckboxState {
    case normal
    case disabled
}

public final class LabeledCheckbox: UIView {
    // MARK: - Public properties

    public var tapHandler: (() -> Void)?

    public var attributedText: NSMutableAttributedString? {
        didSet {
            label.attributedText = attributedText
        }
    }

    public var state: CheckboxState = .normal {
        didSet {
            updateState()
        }
    }

    /// Выбран ли чек-бокс.
    public var isChecked: Bool {
        return checkbox.isSelected
    }

    // MARK: - Views

    private lazy var checkbox: UIButton = {
        let button = UIButton()
        let disabledAndSelectedState = UIControl.State.selected.union(UIControl.State.disabled)
        button.setImage(state.checkboxImage(isSelected: false), for: .normal)
        button.setImage(state.checkboxImage(isSelected: true), for: .selected)
        button.setImage(state.checkboxImage(isSelected: true), for: disabledAndSelectedState)
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return button
    }()

    private lazy var label: UITextView = {
        let label = UITextView()
        label.backgroundColor = .clear
        label.font = Fonts.Styles.caption
        label.isEditable = false
        label.isScrollEnabled = false
        label.isSelectable = true
        label.isUserInteractionEnabled = true
        label.textColor = Colors.Text.primary.color
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        label.linkTextAttributes = [
            .foregroundColor: Colors.Text.primary.color
        ]
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkbox, label])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = Constants.horizontalSpacing
        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        updateState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setupConstraints()
        updateState()
    }
}

// MARK: - Private methods

extension LabeledCheckbox {
    fileprivate func addSubviews() {
        addSubview(stackView)
    }

    fileprivate func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        checkbox.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.checkboxSize)
        }
    }

    fileprivate func updateState() {
        checkbox.isEnabled = state == .normal
        renderState()
    }

    fileprivate func renderState() {
        checkbox.tintColor = state.checkboxColor
        label.textColor = state.textColor
        label.linkTextAttributes = [
            .foregroundColor: state.textColor
        ]
    }

    @objc
    fileprivate func checkboxTapped() {
        checkbox.isSelected.toggle()
        tapHandler?()
    }
}

// MARK: - CheckboxState

extension CheckboxState {
    fileprivate var checkboxColor: UIColor {
        switch self {
            case .normal:
                return Colors.Text.primary.color

            case .disabled:
                return Colors.Controls.disabled.color
        }
    }

    fileprivate var textColor: UIColor {
        switch self {
            case .normal:
                return Colors.Text.primary.color

            case .disabled:
                return Colors.Controls.disabled.color
        }
    }

    fileprivate func checkboxImage(isSelected: Bool) -> UIImage? {
        isSelected
            ? Assets.Controls.Checkbox.checkboxSelected.image.withRenderingMode(.alwaysTemplate)
            : Assets.Controls.Checkbox.checkboxUnselected.image.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - Constants

extension LabeledCheckbox {
    fileprivate enum Constants {
        static let checkboxSize: CGFloat = 24.0
        static let horizontalSpacing: CGFloat = 15.0
    }
}
