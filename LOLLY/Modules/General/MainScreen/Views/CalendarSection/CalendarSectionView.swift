//
//  CalendarSectionView.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.10.2025.
//

private import SnapKit
import UIKit

public final class CalendarSectionView: UIView, ViewModellable {
    public typealias ViewModel = CalendarSectionViewModel?

    public var viewModel: ViewModel {
        didSet {
            updateUI()
        }
    }

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = Fonts.Styles.title1
        label.textColor = Colors.Text.primary.color
        return label
    }()

    private lazy var eventView: EventView = {
        let view = EventView()
        return view
    }()

    private lazy var calendarView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 24.0
        view.clipsToBounds = true
        view.backgroundColor = Colors.Text.inverted.color

        return view
    }()

    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.sectionInset = UIEdgeInsets(top: .zero, left: -74, bottom: .zero, right: 16.0)
        flowLayout.itemSize = CGSize(width: CalendarCell.fixedSize, height: CalendarCell.fixedSize)
        return flowLayout
    }()

    private lazy var calendarCollectionView: UICollectionView = {
        let collectionView = IntrinsicCollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellClass(CalendarCell.self)
        collectionView.isHiddenWhenSkeletonIsActive = true
        return collectionView
    }()

    // MARK: - Private properties

    private var calendarCells: [CalendarCellViewModel] = []

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

extension CalendarSectionView {
    public func setupLayout() {
        addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(Constants.spacing)
        }

        calendarView.addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(24)
        }

        calendarView.addSubview(calendarCollectionView)
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(CalendarCell.fixedSize)
        }

        addSubview(eventView)
        eventView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(Constants.spacing)
            make.left.right.equalToSuperview().inset(Constants.spacing)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    public func setupUI() {
        layer.cornerRadius = 18.0
        clipsToBounds = true
        backgroundColor = Colors.secondaryColor.color

        updateUI()
    }

    public func setupBehaviour() { }

    public func updateUI() {
        isHidden = viewModel == nil

        guard let viewModel else { return }

        if viewModel.isSkeletonable {
            displaySkeleton()
        } else {
            dismissSkeleton()
        }

        monthLabel.text = viewModel.month
        calendarCells = viewModel.days
        eventView.viewModel = viewModel.event
    }
}

// MARK: - SkeletonCallable

extension CalendarSectionView: SkeletonCallable {
    public func prepareForDisplaySkeleton() { }

    public func prepareForDismissSkeleton() { }
}

// MARK: - UICollectionViewDelegate

extension CalendarSectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Обработка нажатия на ячейку даты
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarSectionView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return calendarCells.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let viewModel = calendarCells[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            ofType: CalendarCell.self,
            at: indexPath
        )
        cell.viewModel = viewModel
        return cell
    }
}

extension CalendarSectionView {
    fileprivate enum Constants {
        static let spacing: CGFloat = 18
    }
}
