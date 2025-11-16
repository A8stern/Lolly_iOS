//
//  QuestionScreenView.swift
//  LOLLY
//
//  Created by Егор on 08.11.2025.
//

private import SnapKit
import UIKit

public final class QuestionScreenView: UIView {
    // MARK: - Public Properties

    public var onOptionSelected: ((Int) -> Void)?

    // MARK: - Private Properties

    private var optionButtons: [QuestionOptionButton] = []
    private var circleConstraint: Constraint?

    private lazy var pageIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.Styles.title3
        label.textColor = Colors.accentColor.color
        return label
    }()

    private lazy var circleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Constants.grey.color.withAlphaComponent(0.1)
        return view
    }()

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.Styles.title1
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var optionsStackView: StackView = {
        let stackView = StackView(axis: .vertical, space: Constants.optionsSpacing)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    // MARK: - Initialization

    public init() {
        super.init(frame: .zero)

        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    public func configure(pageNumber: Int, totalPages: Int, question: String, options: [String], circleSize: CGFloat) {
        pageIndicatorLabel.text = "\(pageNumber)/\(totalPages)"
        questionLabel.text = question

        // Обновляем размер круга
        circleConstraint?.update(offset: circleSize)
        circleBackgroundView.layer.cornerRadius = circleSize / 2

        // Удаляем старые кнопки
        optionButtons.forEach { $0.removeFromSuperview() }
        optionButtons.removeAll()

        // Создаём новые кнопки
        for (index, option) in options.enumerated() {
            let button = QuestionOptionButton(title: option)
            button.onTap = { [weak self] in
                self?.onOptionSelected?(index)
            }
            optionButtons.append(button)
            optionsStackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Setup

extension QuestionScreenView {
    fileprivate func setupLayout() {
        // Декоративный круг на заднем плане
        addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.circleVerticalOffset)
            circleConstraint = make.width.height.equalTo(Constants.defaultCircleSize).constraint
        }

        // Индикатор страницы
        addSubview(pageIndicatorLabel)
        pageIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.pageIndicatorTopOffset)
            make.centerX.equalToSuperview()
        }

        // Вопрос (не привязан к кругу)
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.questionVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.contentHorizontalInset)
        }

        // Скролл с вариантами ответов (не привязан к кругу)
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(Constants.optionsTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.contentHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constants.bottomInset)
        }

        scrollView.addSubview(optionsStackView)
        optionsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }

    fileprivate func setupUI() {
        backgroundColor = Colors.Custom.inverted.color

        circleBackgroundView.layer.cornerRadius = Constants.defaultCircleSize / 2
        circleBackgroundView.clipsToBounds = true
    }
}

// MARK: - Constants

extension QuestionScreenView {
    fileprivate enum Constants {
        static let defaultCircleSize: CGFloat = 300
        static let circleVerticalOffset: CGFloat = -50
        static let pageIndicatorTopOffset: CGFloat = 16
        static let questionVerticalOffset: CGFloat = -100
        static let optionsTopOffset: CGFloat = 32
        static let optionsSpacing: CGFloat = 12
        static let contentHorizontalInset: CGFloat = 40
        static let bottomInset: CGFloat = 24
    }
}
