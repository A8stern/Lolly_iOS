private import SnapKit
internal import UIKit

protocol GameSurveyView: AnyObject, SnackDisplayable {
    func configureStart(viewModel: GameSurveyModels.Start.ViewModel)
    func showStartScreen()
    func showQuestion(viewModel: GameSurveyModels.Question.ViewModel)
    func showCompletion(viewModel: GameSurveyModels.Completion.ViewModel)
    func setLoading(_ isLoading: Bool)
}

final class GameSurveyViewController: UIViewController {
    // MARK: - Internal Properties

    var presenter: GameSurveyPresenter?

    // MARK: - Private Properties

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Text.primary.color
        button.setImage(
            Assets.Controls.close.image.withRenderingMode(.alwaysTemplate),
            for: []
        )
        button.addActionHandler({ [weak self] in
            guard let self else { return }
            presenter?.onCloseTap()
        }, for: .touchUpInside)

        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var startScreenView: StartScreenView = {
        let view = StartScreenView()
        view.onStartTap = { [weak self] in
            self?.presenter?.onStartTap()
        }
        return view
    }()

    private lazy var questionScreenView: QuestionScreenView = {
        let view = QuestionScreenView()
        view.onOptionSelected = { [weak self] optionIndex in
            self?.presenter?.onOptionSelected(optionIndex)
        }
        view.isHidden = true
        return view
    }()

    private lazy var completionScreenView: CompletionScreenView = {
        let view = CompletionScreenView()
        view.onRestartTap = { [weak self] in
            self?.presenter?.onRestartTap()
        }
        view.isHidden = true
        return view
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = Colors.Text.primary.color
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupViews()

        presenter?.onViewDidLoad()
    }
}

// MARK: - Setup

extension GameSurveyViewController {
    fileprivate func setupLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(startScreenView)
        startScreenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(questionScreenView)
        questionScreenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(completionScreenView)
        completionScreenView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.closeButtonTopInset)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(Constants.closeButtonHorizontalInset)
            make.size.equalTo(Constants.closeButtonSize)
        }

        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color
    }
}

// MARK: - GameSurveyView

extension GameSurveyViewController: GameSurveyView {
    func configureStart(viewModel: GameSurveyModels.Start.ViewModel) {
        startScreenView.configure(
            title: viewModel.title,
            subtitle: viewModel.subtitle,
            buttonIconURL: viewModel.buttonIconURL,
            backgroundImageURL: viewModel.backgroundImageURL
        )
    }

    func showStartScreen() {
        startScreenView.isHidden = false
        questionScreenView.isHidden = true
        completionScreenView.isHidden = true
    }

    func showQuestion(viewModel: GameSurveyModels.Question.ViewModel) {
        startScreenView.isHidden = true
        questionScreenView.isHidden = false
        completionScreenView.isHidden = true
        questionScreenView.configure(
            pageNumber: viewModel.pageNumber,
            totalPages: viewModel.totalPages,
            question: viewModel.question,
            options: viewModel.options,
            circleSize: viewModel.circleSize
        )
    }

    func showCompletion(viewModel: GameSurveyModels.Completion.ViewModel) {
        startScreenView.isHidden = true
        questionScreenView.isHidden = true
        completionScreenView.isHidden = false
        completionScreenView.configure(
            title: viewModel.title,
            description: viewModel.description,
            imageURL: viewModel.imageURL
        )
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        view.isUserInteractionEnabled = !isLoading
    }
}

// MARK: - Constants

extension GameSurveyViewController {
    fileprivate enum Constants {
        static let closeButtonSize: CGSize = .init(width: 44, height: 44)
        static let closeButtonHorizontalInset: CGFloat = 16.0
        static let closeButtonTopInset: CGFloat = 8.0
    }
}
