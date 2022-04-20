//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

import AVFoundation

class DiscoveryViewController: UIViewController, UICollectionViewDelegate {
    
    private var sections = Section.allSections
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Audio>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Audio>

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        configureCollectionView()
        configureLayout()
        
    }
    
    private func configureCollectionView() {
            
        view.addSubview(collectionView)
         
        collectionView.backgroundView?.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
            
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        collectionView.registerCellWithNib(identifier: String(describing: GalleryCollectionViewCell.self), bundle: nil)

        collectionView.delegate = self
    
    }
    func fetchData() {
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
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let audio = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
      
      let playerView = AudioPlayerView()
      playerView.selectedAudioIndexPath = indexPath
      playerView.audioFiles = sections
      playerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 80, width: UIScreen.main.bounds.width, height: 80)
      playerView.backgroundColor?.withAlphaComponent(0)
      view.addSubview(playerView)
      UIView.animate(withDuration: 0.25, delay: 0.0001, options: .curveEaseInOut, animations: { playerView.frame = CGRect(x: 0, y: height - 130, width: width, height: 80)}, completion: {_ in })
      
  }
}

extension DiscoveryViewController {
  private func configureLayout() {
    collectionView.register(
        SectionHeaderReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
    )
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
      )
      let itemCount = isPhone ? 1 : 3
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
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
