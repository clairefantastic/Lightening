//
//  DiscoveryViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/16.
//

import UIKit
import AVFoundation

class ImpairedDiscoveryViewController: BaseViewController, UICollectionViewDelegate {
    
    var player: AVPlayer!
    
    var sections = DiscoverySection.allSections
    
    var audios: [Audio] = []
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<DiscoverySection, Audio>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<DiscoverySection, Audio>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Audio Files"
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
        configureCollectionView()
        configureLayout()
        
    }
    
    func setPlayer(url: URL) {
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
            
        player = AVPlayer(playerItem: playerItem)
        player.volume = 300.0
        
        player.play()

    }
    
    func configureCollectionView() {
        
        view.stickSubView(collectionView)
        
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#A2BDC6")
        
        collectionView.registerCellWithNib(identifier: String(describing: GalleryCollectionViewCell.self), bundle: nil)
        
        collectionView.registerCellWithNib(identifier: String(describing: VinylCollectionViewCell.self), bundle: nil)
        
        collectionView.delegate = self
        
        collectionView.isAccessibilityElement = false
        
        collectionView.shouldGroupAccessibilityChildren = true
    }
    
    func fetchData() {
        PublishManager.shared.fetchAudios() { [weak self] result in
            switch result {
                
            case .success(let audios):
                
                if let blockList = UserManager.shared.currentUser?.blockList {
                    
                    self?.audios = []
                    
                    for audio in audios where blockList.contains(audio.authorId ?? "") == false {
                        
                        self?.audios.append(audio)
                        
                    }
                    
                } else {
                    
                    self?.audios = audios
                }
                
                self?.sections[0].audios = []
                
                self?.sections[0].audios.append(contentsOf: self?.audios.filter { $0.topic == "Pop"} ?? [])
                
                self?.sections[1].audios = []
                
                self?.sections[1].audios.append(contentsOf: self?.audios.filter { $0.topic == "Indie"} ?? [])
                
                self?.sections[2].audios = []
                
                self?.sections[2].audios.append(contentsOf: self?.audios.filter { $0.topic == "Folk"} ?? [])
                
                self?.sections[3].audios = []
                
                self?.sections[3].audios.append(contentsOf: self?.audios.filter { $0.topic == "City"} ?? [])
                
                self?.sections[4].audios = []
                
                self?.sections[4].audios.append(contentsOf: self?.audios.filter { $0.topic == "Cafe"} ?? [])
                
                self?.sections[5].audios = []
                
                self?.sections[5].audios.append(contentsOf: self?.audios.filter { $0.topic == "Meaningful"} ?? [])
                
                self?.sections[6].audios = []
                
                self?.sections[6].audios.append(contentsOf: self?.audios.filter { $0.topic == "Nature"} ?? [])
                
                self?.sections[7].audios = []
                
                self?.sections[7].audios.append(contentsOf: self?.audios.filter { $0.topic == "Animal"} ?? [])
                
                self?.sections[8].audios = []
                
                self?.sections[8].audios.append(contentsOf: self?.audios.filter { $0.topic == "Others"} ?? [])
                
                self?.applySnapshot(animatingDifferences: false)
                
                LKProgressHUD.dismiss()
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
                
                LKProgressHUD.showFailure(text: "Fail to fetch Discovery Page data")
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
    
    @objc func cellLongPress(_ sender: UILongPressGestureRecognizer) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let touchPoint = sender.location(in: self.collectionView)
        
        if (sender.state == UIGestureRecognizer.State.ended) {
            
            let indexPath = self.collectionView.indexPathForItem(at: touchPoint)
            
            if indexPath != nil && self.sections[indexPath?.section ?? 0].audios[indexPath?.row ?? 0].authorId ?? "" != UserManager.shared.currentUser?.userId {
                let blockUserAlertController = UIAlertController(title: "Select an action", message: "Please select an action you want to execute.", preferredStyle: .actionSheet)
                
                // iPad specific code
                blockUserAlertController
                        let xOrigin = self.view.bounds.width / 2
                        
                        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
                        
                blockUserAlertController.popoverPresentationController?.sourceRect = popoverRect
                        
                blockUserAlertController.popoverPresentationController?.permittedArrowDirections = .up

                let blockUserAction = UIAlertAction(title: "Block This User", style: .destructive) { _ in
                    
                    let controller = UIAlertController(title: "Are you sure?",
                                                       message: "You can't see this user's audio files and comments after blocking, and you won't have chance to unblock this user in the future.",
                                                       preferredStyle: .alert)
                    let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
                        
                        UserManager.shared.blockUser(userId: self.sections[indexPath?.section ?? 0].audios[indexPath?.row ?? 0].authorId ?? "") { result in
                            switch result {
                            case .success(let success):
                                print(success)
                            case .failure(let error):
                                print(error)
                            }
                            
                        }
                       
                    }
                    controller.addAction(blockAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    controller.addAction(cancelAction)
                    self.present(controller, animated: true, completion: nil)

                }
                      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

                          blockUserAlertController.dismiss(animated: true, completion: nil)
                      }

                blockUserAlertController.addAction(blockUserAction)
                blockUserAlertController.addAction(cancelAction)

                present(blockUserAlertController, animated: true, completion: nil)
            }
        }
    }
}

extension ImpairedDiscoveryViewController {
    
    func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let audio = dataSource.itemIdentifier(for: indexPath) else { return }
        
        DispatchQueue.main.async {
            LKProgressHUD.show()
        }
        DispatchQueue.global().async {
            self.setPlayer(url: audio.audioUrl)
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
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}
