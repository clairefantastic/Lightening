//
//  MyProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/1.
//

import UIKit

class MyProfileViewController: BaseViewController {
    
    private let vinylImageView = UIImageView()
    
    private let userProfileView = UserProfileView()
    
    private let lightImageView = UIImageView()
    
    private let myAudiosButton = UIButton()
    
    private let seeMoreButton = UIButton()
    
    private var myAudios: [Audio]?
    
    private var likedAudios: [Audio]?
    
    private var hideLightBeam: Bool? {
        
        didSet {
            
            if hideLightBeam == false {
                
                lightImageView.isHidden = false
                
                seeMoreButton.isHidden = false
                
            } else {
                
                lightImageView.isHidden = true
                
                seeMoreButton.isHidden = true
            }
        }
    }
    
    private var myAudiosButtonIsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVinylImageView()
        addUserProfileView()
        configureLightImageView()
        configureButtons()
        fetchMyAudios()
        fetchLikedAudios()
        ElementsStyle.styleClearBackground(lightImageView)
        ElementsStyle.styleViewBackground(userProfileView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.userProfileView.addGestureRecognizer(tapGestureRecognizer)
        self.userProfileView.imageUrl = UserManager.shared.currentUser?.image?.absoluteString
    }
    
    private func fetchMyAudios() {
        
        PublishManager.shared.fetchAudios() { [weak self] result in
            
            switch result {
                
            case .success(let audios):
                
                self?.myAudios = audios.filter { $0.author?.userId == UserManager.shared.currentUser?.userId}
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
        
    }

    private func fetchLikedAudios() {

        PublishManager.shared.fetchLikedAudios(userId: UserManager.shared.currentUser?.userId ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let likedAudios):
                
                self?.likedAudios = likedAudios
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
    }
    
    
    @objc func didTapProfileView() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self

        let imagePickerAlertController = UIAlertController(title: "Upload Profile Photo", message: "Please select a photo for your profile", preferredStyle: .actionSheet)

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
}

extension MyProfileViewController {
    
    private func configureVinylImageView() {
        
        vinylImageView.image = UIImage(named: "profileVinyl")
        
        view.stickSubView(vinylImageView)
    
    }
    
    private func addUserProfileView() {
        
        userProfileView.addProfileImageView()
    
        self.view.stickSubView(userProfileView, inset: UIEdgeInsets(top: 80, left: width - 160, bottom: height - 240, right: 24))
        
    }
    
    private func configureLightImageView() {
        
        self.view.addSubview(lightImageView)
        
        lightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: lightImageView, attribute: .top, relatedBy: .equal, toItem: self.userProfileView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: lightImageView, attribute: .centerX, relatedBy: .equal, toItem: self.userProfileView, attribute: .centerX, multiplier: 1, constant: -150).isActive = true
        
        NSLayoutConstraint(item: lightImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300).isActive = true
        
        NSLayoutConstraint(item: lightImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400).isActive = true
        
        lightImageView.image = UIImage(named: "light")
        
        hideLightBeam = true
    
    }
    
    private func configureButtons() {
        
        self.view.addSubview(myAudiosButton)
        
        myAudiosButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: myAudiosButton, attribute: .bottom, relatedBy: .equal, toItem: self.lightImageView, attribute: .bottom, multiplier: 1, constant: -36).isActive = true
        
        NSLayoutConstraint(item: myAudiosButton, attribute: .centerX, relatedBy: .equal, toItem: self.userProfileView, attribute: .centerX, multiplier: 1, constant: -170).isActive = true
        
        NSLayoutConstraint(item: myAudiosButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: myAudiosButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        myAudiosButton.setTitle("My Audios", for: .normal)
        
        myAudiosButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#F1E6B9"), for: .normal)
        
        myAudiosButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#13263B"), for: .selected)
        
        myAudiosButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 16)
        
        myAudiosButton.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
        
        self.view.addSubview(seeMoreButton)
        
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: seeMoreButton, attribute: .top, relatedBy: .equal, toItem: myAudiosButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: seeMoreButton, attribute: .centerX, relatedBy: .equal, toItem: myAudiosButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: seeMoreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: seeMoreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        seeMoreButton.setTitle("See More", for: .normal)
        
        seeMoreButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#F1E6B9"), for: .normal)
        
        seeMoreButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 14)
        
        seeMoreButton.addTarget(self, action: #selector(didTapSeeMore), for: .touchUpInside)
        
    }
    
    @objc func selectButton() {
        
        if myAudiosButtonIsSelected == false {
            
            myAudiosButton.isSelected = true
            
            hideLightBeam = false
            
            myAudiosButtonIsSelected = true
            
        } else {
            
            myAudiosButton.isSelected = false
            
            hideLightBeam = true
            
            myAudiosButtonIsSelected = false
            
        }
        
    }
    
    @objc func didTapSeeMore() {
        
        let myAudioListViewController = MyAudioListViewController()
        myAudioListViewController.audios = myAudios
        self.navigationController?.pushViewController(myAudioListViewController, animated: true)
    }
       
}

extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
