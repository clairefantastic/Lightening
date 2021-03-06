//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

class ImpairedDiscoveryViewController: BaseViewController {
    
    private var collectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var audios: [Audio] = []
    var sections = DiscoverySection.allSections
    lazy var dataSource = makeDataSource()
    typealias DataSource = UICollectionViewDiffableDataSource<DiscoverySection, Audio>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiscoverySection, Audio>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = VisuallyImpairedTab.discovery.tabBarItem().title
        
        configureCollectionView()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    func configureCollectionView() {
        
        view.stickSubView(collectionView)
        
        collectionView.backgroundColor = UIColor.lightBlue
        
        collectionView.registerCellWithNib(identifier: String(describing: VinylCollectionViewCell.self), bundle: nil)
        
        collectionView.register(SectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        
        collectionView.delegate = self
        
        collectionView.isAccessibilityElement = false
        collectionView.shouldGroupAccessibilityChildren = true
    }
    
    func fetchData() {
        PublishManager.shared.fetchAudios { [weak self] result in
            
            switch result {
                
            case .success(let audios):
                
                if let blockList = UserManager.shared.currentUser?.blockList {
                    
                    self?.audios = []
                    
                    for audio in audios where blockList.contains(audio.authorId) == false {
                        
                        self?.audios.append(audio)
                    }
                    
                } else {
                    
                    self?.audios = audios
                }
                
                for topic in 0..<(self?.sections.count ?? 0) {
                    
                    self?.sections[topic].audios = []
                    
                    self?.sections[topic].audios.append(contentsOf: self?.audios.filter { $0.topic == AudioTopics.allCases[topic].rawValue} ?? [])
                }
                
                self?.applySnapshot(animatingDifferences: false)
                
                LKProgressHUD.dismiss()
                
            case .failure:
                
                LKProgressHUD.showFailure(text: PublishError.fetchAudiosError.errorMessage)
            }
            
        }
    }
    
    private func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, audio) ->
                UICollectionViewCell? in
            
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: VinylCollectionViewCell.self),
                    for: indexPath) as? VinylCollectionViewCell
                cell?.audio = audio
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPress))
                
                cell?.addGestureRecognizer(longPress)
                
                return cell
                
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            
            view?.title = section.topic
            
            view?.didTapSectionHandler = { [weak self] in
                let audioListViewController = AudioListViewController()
                audioListViewController.audios = section.audios
                self?.navigationController?.pushViewController(audioListViewController, animated: true)
            }
            return view
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.audios, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    @objc func cellLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let touchPoint = sender.location(in: self.collectionView)
        
        if sender.state == .ended {
                
            if let selectedIndexPath = self.collectionView.indexPathForItem(at: touchPoint) {
                
                if self.sections[selectedIndexPath.section].audios[selectedIndexPath.item].authorId != UserManager.shared.currentUser?.userId {
                    
                    showBlockUserAlert(blockUserId: self.sections[selectedIndexPath.section].audios[selectedIndexPath.row].authorId)
                }
            }
        }
    }
}

extension ImpairedDiscoveryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let audio = dataSource.itemIdentifier(for: indexPath) else { return }
        
        DispatchQueue.main.async {
            LKProgressHUD.show()
        }
        
        DispatchQueue.global().async {
            AVPlayerHandler.shared.setPlayer(url: audio.audioUrl)
        }
        
        DispatchQueue.main.async {
            LKProgressHUD.dismiss()
        }
    }
}

extension ImpairedDiscoveryViewController {
    
    func configureLayout() {
        collectionView.register(SectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (_, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(2/5),
                heightDimension: NSCollectionLayoutDimension.absolute(200)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 0
            // Supplementary header view setup
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }
}
