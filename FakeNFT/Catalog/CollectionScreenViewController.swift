//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 01.04.2024.
//
import UIKit
final class CollectionScreenViewController: UIViewController {

    private lazy var mainImageView = UIImageView()

    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .top
        return stack
    }()

    private lazy var authorStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.init(hexString: "#0A84FF")
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()

    private lazy var backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var collectionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(NFTCollectionsViewCell.self, forCellWithReuseIdentifier: NFTCollectionsViewCell.identifier)
//        view.register(HeaderCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                      withReuseIdentifier: HeaderCellView.identifier)
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        drawSelf()
    }

    private func drawSelf() {
        view.backgroundColor = .white
        [mainImageView, titleLabel, labelStackView,
         descriptionLabel, backgroundScrollView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            view.addSubview($0)
        }

        [authorStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            labelStackView.addArrangedSubview($0)
        }

        [authorLabel,
         linkLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
            authorStackView.addArrangedSubview($0)
        }

        [contentView, collectionsCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
        backgroundScrollView.addSubview(contentView)
        contentView.addSubview(collectionsCollectionView)

        let equalHeight = contentView.heightAnchor.constraint(equalToConstant: 850)
        equalHeight.priority = UILayoutPriority(250)


        //MARK: Удалить
        mainImageView.backgroundColor = .yellow
        titleLabel.text = "Peach"
        authorLabel.text = "Автор коллекции:"
        descriptionLabel.text = "Персиковый - как облака над закатным солнцем в океане. В этой коллекции совмещены тогательная нежность и живая игривость сказочных зифирных зверей"
        linkLabel.text = "Jhon Doe"

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 310),

            titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            labelStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelStackView.heightAnchor.constraint(equalToConstant: 64),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),

            backgroundScrollView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            equalHeight,

            collectionsCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            collectionsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: -UICollectionViewDataSource
extension CollectionScreenViewController: UICollectionViewDataSource {

    func numberOfSections(in: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionsViewCell.identifier,
                                                            for: indexPath) as? NFTCollectionsViewCell else {
            return UICollectionViewCell()
        }
//        cell.delegate = self
//        configCell(for: cell, with: indexPath)
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                         withReuseIdentifier: HeaderCellView.identifier,
//                                                                         for: indexPath) as? HeaderCellView else {
//            return UICollectionReusableView()
//        }
//
//        view.prepareView(name: filterDateCategories[indexPath.section].name)
//        return view
//    }
}

//MARK: - UICollectionViewDelegate

extension CollectionScreenViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView,
//                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
//                        point: CGPoint) -> UIContextMenuConfiguration? {
//        guard indexPaths.count > 0 else {
//            return nil
//        }
//
//        let fix = NSLocalizedString("trackerView.uiMenu.fix",
//                                    comment: "Text displayed context menu settings")
//        let unFix = NSLocalizedString("trackerView.uiMenu.unFix",
//                                      comment: "Text displayed context menu settings")
//        let edit = NSLocalizedString("trackerView.uiMenu.edit",
//                                     comment: "Text displayed context menu settings")
//        let delete = NSLocalizedString("trackerView.uiMenu.delete",
//                                       comment: "Text displayed context menu settings")
//        let deleteMassage = NSLocalizedString("trackerView.uiMenu.deleteMessage",
//                                              comment: "Text displayed in alarm")
//        let cancelButtonName = NSLocalizedString("createNewHabitView.cancelButtonName",
//                                                 comment: "Text displayed like name of cance button")
//
//        let indexPath = indexPaths[0]
//
//        var trackerUUIDs: [UUID] = []
//        fixedTrackers.forEach{trackerUUIDs.append($0.id)}
//
//        if trackerUUIDs.contains(filterDateCategories[indexPath.section].trackers[indexPath.row].id) {
//            return UIContextMenuConfiguration(actionProvider: { actions in
//                return UIMenu(children: [
//                    UIAction(title: unFix) { [weak self] _ in
//                        self?.unFixTracker(indexPath: indexPath)
//                    },
//                    UIAction(title: edit) { [weak self] _ in
//                        self?.editTracker(indexPath: indexPath)
//                    },
//                    UIAction(title: delete, attributes: .destructive) { [weak self] _ in
//                        let alert = UIAlertController(title: "", message: deleteMassage, preferredStyle: .actionSheet)
//                        let deleteButton = UIAlertAction(title: delete, style: .destructive, handler: { _ in
//                            self?.deleteTracker(indexPath: indexPath)
//                        })
//                        let canselButton = UIAlertAction(title: cancelButtonName, style: .cancel, handler: { _ in })
//                        alert.addAction(deleteButton)
//                        alert.addAction(canselButton)
//                        self?.present(alert, animated: true, completion: nil)
//                    },
//                ])
//            })
//        } else {
//            return UIContextMenuConfiguration(actionProvider: { actions in
//                return UIMenu(children: [
//                    UIAction(title: fix) { [weak self] _ in
//                        self?.fixTracker(indexPath: indexPath)
//                    },
//                    UIAction(title: edit) { [weak self] _ in
//                        self?.editTracker(indexPath: indexPath)
//                    },
//                    UIAction(title: delete, attributes: .destructive) { [weak self] _ in
//                        let alert = UIAlertController(title: "", message: deleteMassage, preferredStyle: .actionSheet)
//                        let deleteButton = UIAlertAction(title: delete, style: .destructive, handler: { _ in
//                            self?.deleteTracker(indexPath: indexPath)
//                        })
//                        let canselButton = UIAlertAction(title: cancelButtonName, style: .cancel, handler: { _ in })
//                        alert.addAction(deleteButton)
//                        alert.addAction(canselButton)
//                        self?.present(alert, animated: true, completion: nil)
//                    },
//                ])
//            })
//        }
//    }
}

//MARK: -UICollectionViewDelegateFlowLayout
extension CollectionScreenViewController: UICollectionViewDelegateFlowLayout {

    private var params: GeometricParams {
        return GeometricParams(cellCount: 3,
                               leftInset: 0,
                               rightInset: 0,
                               cellSpacing: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSize(collectionView: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: params.cellSpacing,
                     left: params.leftInset,
                     bottom: params.cellSpacing,
                     right: params.rightInset)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let size = getSize(collectionView: collectionView)
//        return CGSize(width: size.width, height: size.height / 5)
//    }

    private func getSize(collectionView: UICollectionView) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: 192)
    }
}
