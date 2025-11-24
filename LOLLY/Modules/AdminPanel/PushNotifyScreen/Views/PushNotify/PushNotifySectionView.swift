//
//  PushNotifySectionView.swift
//  LOLLY
//
//  Created by Nikita on 23.11.2025.
//

private import SnapKit
import UIKit

public final class PushNotifySectionView: UIView, ViewModellable {
    public typealias ViewModel = PushNotifySectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI

    private lazy var generalStack: StackView = {
        let view = StackView(axis: .vertical, space: 16)
        view.alignment = .center
        return view
    }()

    private lazy var fSectionsStack: StackView = {
        let view = StackView(axis: .horizontal)
        view.alignment = .center
        return view
    }()

    private lazy var titleTextView: TextView = {
        let field = TextView()
        return field
    }()

    private lazy var mainTextView: TextView = {
        let field = TextView()
        return field
    }()

    private lazy var confirmButton: Button = {
        let button = Button()
        return button
    }()

    // MARK: - Lifecycle

    public init(viewModel: ViewModel = nil) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupLayout()
        setupUI()
        setupBehaviour()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfigurable

extension PushNotifySectionView {
    public func setupLayout() {
        addSubview(generalStack)
        generalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        generalStack.addArrangedSubviews(titleTextView, mainTextView, confirmButton)
        titleTextView.snp.makeConstraints{make in
            make.width.equalToSuperview()
        }
        mainTextView.snp.makeConstraints{make in
            make.width.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(120)
        }
    }

    public func setupUI() {
        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel else { return }

        titleTextView.title = viewModel.titleInputViewModel.title
        titleTextView.placeholder = viewModel.titleInputViewModel.placeholder
        titleTextView.keyboardType = viewModel.titleInputViewModel.keyboardType
        titleTextView.maxLength = viewModel.titleInputViewModel.maxLength

        mainTextView.title = viewModel.textInputViewModel.title
        mainTextView.placeholder = viewModel.textInputViewModel.placeholder
        mainTextView.keyboardType = viewModel.textInputViewModel.keyboardType
        mainTextView.maxLength = viewModel.textInputViewModel.maxLength

        confirmButton.viewModel = viewModel.confirmButtonViewModel
    }
}

// MARK: - Constants

extension PushNotifySectionView {
    fileprivate enum Constants { }
}
