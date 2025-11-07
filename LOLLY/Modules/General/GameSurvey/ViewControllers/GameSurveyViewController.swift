private import SnapKit
internal import UIKit

protocol GameSurveyView: AnyObject { }

final class GameSurveyViewController: UIViewController {
    // MARK: - Internal Properties

    var presenter: GameSurveyPresenter?

    // MARK: - Private Properties

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.Text.primary.color
        button.setImage(Assets.Controls.close.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(onCloseTap), for: .touchUpInside)
        return button
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
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.closeButtonTopInset)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(Constants.closeButtonHorizontalInset)
            make.size.equalTo(Constants.closeButtonSize)
        }
    }

    fileprivate func setupViews() {
        view.backgroundColor = Colors.Custom.inverted.color
    }

    @objc
    fileprivate func onCloseTap() {
        presenter?.onCloseTap()
    }
}

// MARK: - GameSurveyView

extension GameSurveyViewController: GameSurveyView { }

// MARK: - Constants

extension GameSurveyViewController {
    fileprivate enum Constants {
        static let closeButtonSize: CGSize = .init(width: 44, height: 44)
        static let closeButtonHorizontalInset: CGFloat = 16.0
        static let closeButtonTopInset: CGFloat = 8.0
    }
}
