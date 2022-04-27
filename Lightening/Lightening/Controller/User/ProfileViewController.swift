//
//  ProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit
import FirebaseAuth

class ProfileViewController: BaseViewController, UICollectionViewDelegate {
    
    private let userProfileView = UserProfileView()
    
    private let logOutButton = UIButton()
    
    private var sections = ProfileSection.allSections
    
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<ProfileSection, Audio>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<ProfileSection, Audio>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserProfileView()
        fetchMyAudios()
        fetchLikedAudios()
        configureCollectionView()
        configureLayout()
        configureLogOutButton()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.userProfileView.addGestureRecognizer(tapGestureRecognizer)
        self.userProfileView.imageUrl = UserManager.shared.currentUser?.image?.absoluteString
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.userProfileView.profileImageView.layer.cornerRadius = self.userProfileView.profileImageView.frame.height / 2
    }
    
    @objc func didTapProfileView() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self

        let imagePickerAlertController = UIAlertController(title: "UploadPhoto", message: "Please select photo", preferredStyle: .actionSheet)

              // 建立三個 UIAlertAction 的實體
              // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "Photo Library", style: .default) { _ in

                  // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

                      // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
              let imageFromCameraAction = UIAlertAction(title: "Camera", style: .default) { _ in

                  // 判斷是否可以從相機取得照片來源
                  if UIImagePickerController.isSourceTypeAvailable(.camera) {

                      // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                      imagePickerController.sourceType = .camera
                      self.present(imagePickerController, animated: true, completion: nil)
                  }
              }

              // 新增一個取消動作，讓使用者可以跳出 UIAlertController
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

                  imagePickerAlertController.dismiss(animated: true, completion: nil)
              }

              // 將上面三個 UIAlertAction 動作加入 UIAlertController
              imagePickerAlertController.addAction(imageFromLibAction)
              imagePickerAlertController.addAction(imageFromCameraAction)
              imagePickerAlertController.addAction(cancelAction)

              // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
              present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    private func configureCollectionView() {
        
        view.stickSubView(collectionView, inset: UIEdgeInsets(top: 260, left: 0, bottom: 0, right: 0))
        
        collectionView.backgroundColor = UIColor.hexStringToUIColor(hex: "#D65831")
        
        collectionView.registerCellWithNib(identifier: String(describing: GalleryCollectionViewCell.self), bundle: nil)
        
        collectionView.delegate = self
    }
    
    private func fetchMyAudios() {
        
        PublishManager.shared.fetchAudios() { [weak self] result in
            
            switch result {
                
            case .success(let audios):
                
                self?.sections[0].audios.append(contentsOf: audios.filter { $0.author?.userId == UserManager.shared.currentUser?.userId})
                self?.applySnapshot(animatingDifferences: true)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
        
    }

    private func fetchLikedAudios() {

        PublishManager.shared.fetchLikedAudios(userId: UserManager.shared.currentUser?.userId ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let likedAudios):
                
                self?.sections[1].audios = likedAudios
                self?.applySnapshot(animatingDifferences: true)
                
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
            view?.titleLabel.text = section.category
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

extension ProfileViewController {
    
    private func addUserProfileView() {
        
        self.view.stickSubView(userProfileView, inset: UIEdgeInsets(top: 80, left: width - 160, bottom: height - 240, right: 24))
        
        userProfileView.backgroundColor =  UIColor.hexStringToUIColor(hex: "#D65831")
    }
    
    private func configureLogOutButton() {
        
        view.addSubview(logOutButton)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: logOutButton, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .top, multiplier: 1, constant: -8).isActive = true
        
        NSLayoutConstraint(item: logOutButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: logOutButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: logOutButton, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -60).isActive = true
        
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#13263B"), for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 16)
        logOutButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#F7E3E8")
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        logOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
    }
    
    @objc func signOut() {
        
        UserManager.shared.signOut()
        print(Auth.auth().currentUser?.email)
        view.window?.rootViewController = SignInViewController()
        view.window?.makeKeyAndVisible()
    }
}

extension ProfileViewController {
    
    func collectionView( _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let audio = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let audioPlayerViewController = AudioPlayerViewController()
        addChild(audioPlayerViewController)
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

extension ProfileViewController {
    
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            PublishManager.shared.getProfilePhotoUrl(selectedImage: selectedImage)
            
            self.userProfileView.profileImageView.image = selectedImage
            
            print("\(selectedImage)")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
