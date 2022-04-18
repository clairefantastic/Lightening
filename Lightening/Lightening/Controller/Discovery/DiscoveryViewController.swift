//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit

import AVFoundation

//class DiscoveryViewController: UIViewController {
//
//    private var tableView = UITableView()
//
//    var audio: Audio? {
//
//        didSet {
//
//            guard let audio = audio
//
//            else { return }
//
////            galleryView.datas = audio.cover
//
//        }
//    }
//
//    var datas: [Audio] = [] {
//
//        didSet {
//
//
//
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.view.backgroundColor = .white
//
//        view.addSubview(tableView)
//
//        setupTableView()
//
//
//    }
//
//    private func setupTableView() {
//
//        view.addSubview(tableView)
//
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//
//        tableView.separatorStyle = .none
//
//        tableView.registerCellWithNib(identifier:
//            String(describing: GalleryTableViewCell.self),
//                                         bundle: nil
//        )
//        tableView.dataSource = self
//
//        tableView.delegate = self
//
//
//    }
//
//
//
//}
//
//extension DiscoveryViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        switch section
//        {
//            case 0:
//                return "City"
////            case 1:
////                return "City"
////            case 2:
////                return "Pet"
//            default:
//                return nil
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalleryTableViewCell.self)) as? GalleryTableViewCell else {
//            return UITableViewCell()
//        }
//
//        cell.openAudioPlayerHandler = { [weak self] index in
//
//            let audioPlayerView = AudioPlayerView()
//
//            audioPlayerView.selectedAudioIndex = index
//
//            audioPlayerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 80)
//            audioPlayerView.backgroundColor?.withAlphaComponent(0)
//            self?.view.addSubview(audioPlayerView)
//
//            UIView.animate(withDuration: 0.25, delay: 0.0001, options: .curveEaseInOut, animations: {[self] in audioPlayerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 130, width: UIScreen.main.bounds.width, height: 80)}, completion: {_ in print("Audio Player Shown")})
//
//        }
//
//        return cell
//    }
//
//
//}
//
//extension DiscoveryViewController: GalleryViewDelegate {
//
//    func sizeForItem(_ galleryView: GalleryView) -> CGSize {
//
//        return CGSize(width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.width / 375.0 * 500.0))
//    }
//
//
//}


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
        AudioManager.shared.fetchAudioFiles() { [weak self] result in
            
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

