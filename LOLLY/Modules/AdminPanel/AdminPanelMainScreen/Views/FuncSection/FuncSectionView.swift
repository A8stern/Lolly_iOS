//
//  FuncSectionView.swift
//  LOLLY
//
//  Created by Nikita on 22.11.2025.
//

private import SnapKit
import UIKit

public final class FuncSectionView: UIView, ViewModellable {
    public typealias ViewModel = FuncSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI

    private lazy var generalStack: StackView = {
        let view = StackView(axis: .vertical, space: 16)
        return view
    }()

    private lazy var functionalSectionsStack: StackView = {
        let view = StackView(axis: .vertical, space: 6)
        return view
    }()

    private lazy var contentSectionsStack: StackView = {
        let view = StackView(axis: .vertical, space: 6)
        return view
    }()

    private lazy var functionalSectionList: StackView = {
        let view = StackView(axis: .vertical)
        return view
    }()

    private lazy var contentSectionList: StackView = {
        let view = StackView(axis: .vertical)
        return view
    }()

    private lazy var functionalSectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = Fonts.TTTravels.regular.font(size: 13)
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    private lazy var contentSectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = Fonts.Styles.custom(weight: .regular, size: 13)
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    private lazy var functionalSectionButton: Button = {
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

extension FuncSectionView {
    public func setupLayout() {
        addSubview(generalStack)
        generalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        generalStack.addArrangedSubview(functionalSectionsStack)
        functionalSectionsStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        functionalSectionsStack.addArrangedSubviews(functionalSectionLabel, functionalSectionList)

        generalStack.addArrangedSubview(contentSectionsStack)
        contentSectionsStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        contentSectionsStack.addArrangedSubviews(contentSectionLabel, contentSectionList)
    }

    public func setupUI() {
        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil

        func clearStack(_ stack: UIStackView) {
            for view in stack.arrangedSubviews {
                stack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        clearStack(functionalSectionList)
        clearStack(contentSectionList)

        guard let viewModel else { return }
        functionalSectionLabel.text = viewModel.fSections.isEmpty ? "" : viewModel.fTitle
        contentSectionLabel.text = viewModel.sSections.isEmpty ? "" : viewModel.sTitle
        for sectionButtonModel in viewModel.fSections {
            let button = SectionButton(viewModel: sectionButtonModel)
            functionalSectionList.addArrangedSubview(button)
        }
        for sectionButtonModel in viewModel.sSections {
            let button = SectionButton(viewModel: sectionButtonModel)
            contentSectionList.addArrangedSubview(button)
        }
    }
}

// MARK: - Constants

extension FuncSectionView {
    fileprivate enum Constants { }
}
