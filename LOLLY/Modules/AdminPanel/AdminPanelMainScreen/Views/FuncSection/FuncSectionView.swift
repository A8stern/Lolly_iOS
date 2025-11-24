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

    private lazy var fSectionsStack: StackView = {
        let view = StackView(axis: .vertical, space: 6)
        return view
    }()

    private lazy var sSectionsStack: StackView = {
        let view = StackView(axis: .vertical, space: 6)
        return view
    }()

    private lazy var fSectionList: StackView = {
        let view = StackView(axis: .vertical)
        return view
    }()

    private lazy var sSectionList: StackView = {
        let view = StackView(axis: .vertical)
        return view
    }()

    private lazy var fSectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = Fonts.TTTravels.regular.font(size: 13)
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    private lazy var sSectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = Fonts.Styles.custom(weight: .regular, size: 13)
        label.textColor = Colors.Text.secondary.color
        return label
    }()

    private lazy var fSectionButton: Button = {
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

        generalStack.addArrangedSubview(fSectionsStack)
        fSectionsStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        fSectionsStack.addArrangedSubviews(fSectionLabel, fSectionList)

        generalStack.addArrangedSubview(sSectionsStack)
        sSectionsStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        sSectionsStack.addArrangedSubviews(sSectionLabel, sSectionList)
    }

    public func setupUI() {
        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil

        func clearStack(_ stack: UIStackView) {
            stack.arrangedSubviews.forEach { view in
                stack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        clearStack(fSectionList)
        clearStack(sSectionList)

        guard let viewModel else { return }
        fSectionLabel.text = viewModel.fSections.isEmpty ? "" : viewModel.fTitle
        sSectionLabel.text = viewModel.sSections.isEmpty ? "" : viewModel.sTitle
        for sectionButtonModel in viewModel.fSections {
            let button = SectionButton(viewModel: sectionButtonModel)
            fSectionList.addArrangedSubview(button)
        }
        for sectionButtonModel in viewModel.sSections {
            let button = SectionButton(viewModel: sectionButtonModel)
            sSectionList.addArrangedSubview(button)
        }
    }
}

// MARK: - Constants

extension FuncSectionView {
    fileprivate enum Constants { }
}
