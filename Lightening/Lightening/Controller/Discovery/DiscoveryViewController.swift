//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

import AVFoundation

class DiscoveryViewController: BaseViewController, UICollectionViewDelegate {
    
    private let mapButton = UIButton()
    
    private var sections = DiscoverySection.allSections
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<DiscoverySection, Audio>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiscoverySection, Audio>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureCollectionView()
        configureLayout()
        layoutBarItem()
        layoutMapButton()
    }
    
    private func configureCollectionView() {
        
        view.stickSubView(collectionView)
        
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#D65831")
        
        collectionView.registerCellWithNib(identifier: String(describing: GalleryCollectionViewCell.self), bundle: nil)
        
        collectionView.delegate = self
    }
    
    private func fetchData() {
        PublishManager.shared.fetchAudioFiles() { [weak self] result in
            switch result {
                
            case .success(let audioFiles):
                
                self?.sections[0].audios.append(contentsOf: audioFiles.filter { $0.topic == "Nature"})
                
                self?.sections[1].audios.append(contentsOf: audioFiles.filter { $0.topic == "City"})
                
                self?.sections[2].audios.append(contentsOf: audioFiles.filter { $0.topic == "Pet"})
                
                self?.sections[3].audios.append(contentsOf: audioFiles.filter { $0.topic == "Others"})
                
                self?.applySnapshot(animatingDifferences: false)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
    }
    
    private func makeDataSource() -> DataSource {
        // 1
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, audio) ->
                UICollectionViewCell? in
                // 2
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: GalleryCollectionViewCell.self),
                    for: indexPath) as? GalleryCollectionViewCell
                cell?.audio = audio
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
            view?.titleLabel.text = section.topic
            return view
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        // 2
        var snapshot = Snapshot()
        // 3
        snapshot.appendSections(sections)
        // 4
        sections.forEach { section in
            snapshot.appendItems(section.audios, toSection: section)
        }
        // 5
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension DiscoveryViewController {
    
    func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let audio = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let audioPlayerViewController = AudioPlayerViewController()
        audioPlayerViewController.audio = sections[indexPath.section].audios[indexPath.row]
        audioPlayerViewController.view.frame = CGRect(x: 0, y: height - 80, width: width, height: 80)
        audioPlayerViewController.view.backgroundColor?.withAlphaComponent(0)
        view.addSubview(audioPlayerViewController.view)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0001,
                       options: .curveEaseInOut,
                       animations: { audioPlayerViewController.view.frame = CGRect(x: 0, y: height - 130, width: width, height: 80)},
                       completion: {_ in })
        
    }
}

extension DiscoveryViewController {
    
    private func configureLayout() {
        collectionView.register(SectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1/3),
                heightDimension: NSCollectionLayoutDimension.absolute(190)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

extension DiscoveryViewController {
    
    private func layoutMapButton() {
        
        self.view.addSubview(mapButton)
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: mapButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -36).isActive = true
        
        NSLayoutConstraint(item: mapButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: mapButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: mapButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        
        mapButton.addTarget(self, action: #selector(pushMapPage), for: .touchUpInside)
    }
    
    @objc func pushMapPage(_ sender: UIButton) {
        
        let mapViewController = MapViewController()
        
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}

extension DiscoveryViewController {
    
    private func layoutBarItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pushSearchPage))
    }
    
    @objc func pushSearchPage(_ sender: UIBarButtonItem) {
        
        let searchViewController = SearchViewController()
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}
