//
//  MyProfileViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/1.
//

import UIKit
import FirebaseAuth

class MyProfileViewController: ImpairedProfileViewController {
    
    private let lightImageView = UIImageView()
    
    private let rightLightImageView = UIImageView()
    
    private let myAudiosButton = UIButton()
    
    private let likedAudiosButton = UIButton()
    
    private let seeMyAudiosButton = UIButton()
    
    private let seeLikedAudiosButton = UIButton()
    
    private var myAudios: [Audio]?
    
    private var likedAudios: [Audio]?
    
    private var hideLeftLightBeam: Bool? {
        
        didSet {
            
            if hideLeftLightBeam == false {
                
                lightImageView.isHidden = false
                
                seeMyAudiosButton.isHidden = false
                
            } else {
                
                lightImageView.isHidden = true
                
                seeMyAudiosButton.isHidden = true
            }
        }
    }
    
    private var hideRightLightBeam: Bool? {
        
        didSet {
            
            if hideRightLightBeam == false {
                
                rightLightImageView.isHidden = false
                
                seeLikedAudiosButton.isHidden = false
                
                likedAudiosButton.tintColor = UIColor.hexStringToUIColor(hex: "#13263B")
                
            } else {
                
                rightLightImageView.isHidden = true
                
                seeLikedAudiosButton.isHidden = true
                
                likedAudiosButton.tintColor = UIColor.hexStringToUIColor(hex: "#F1E6B9")
            }
        }
    }
    
    private var myAudiosButtonIsSelected = false
    
    private var likedAudiosButtonIsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVinylImageView()
        addUserProfileView()
        configureLightImageView()
        configureButtons()
        fetchMyAudios()
        fetchLikedAudios()
        configureLogOutButton()
        configureDeleteAccountButton()
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
    
    private func configureLightImageView() {
        
        self.view.addSubview(lightImageView)
        
        lightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: lightImageView, attribute: .top, relatedBy: .equal, toItem: self.userProfileView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: lightImageView, attribute: .centerX, relatedBy: .equal, toItem: self.userProfileView, attribute: .centerX, multiplier: 1, constant: -150).isActive = true
        
        NSLayoutConstraint(item: lightImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320).isActive = true
        
        NSLayoutConstraint(item: lightImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400).isActive = true
        
        lightImageView.image = UIImage(named: "leftLight")
        
        hideLeftLightBeam = true
        
        self.view.addSubview(rightLightImageView)
        
        rightLightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: rightLightImageView, attribute: .top, relatedBy: .equal, toItem: self.userProfileView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: rightLightImageView, attribute: .centerX, relatedBy: .equal, toItem: self.userProfileView, attribute: .centerX, multiplier: 1, constant: -80).isActive = true
        
        NSLayoutConstraint(item: rightLightImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350).isActive = true
        
        NSLayoutConstraint(item: rightLightImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
        
        rightLightImageView.image = UIImage(named: "leftLight")
        
        hideLeftLightBeam = true
        
        hideRightLightBeam = true
    
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
        
        myAudiosButton.titleLabel?.font = UIFont(name: "American Typewriter Bold", size: 16)
        
        myAudiosButton.addTarget(self, action: #selector(selectMyAudiosButton), for: .touchUpInside)
        
        self.view.addSubview(seeMyAudiosButton)
        
        seeMyAudiosButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: seeMyAudiosButton, attribute: .top, relatedBy: .equal, toItem: myAudiosButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: seeMyAudiosButton, attribute: .centerX, relatedBy: .equal, toItem: myAudiosButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: seeMyAudiosButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: seeMyAudiosButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        seeMyAudiosButton.setTitle("See More", for: .normal)
        
        seeMyAudiosButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#F1E6B9"), for: .normal)
        
        seeMyAudiosButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 14)
        
        seeMyAudiosButton.addTarget(self, action: #selector(didTapSeeMoreMyAudios), for: .touchUpInside)
        
        self.view.addSubview(likedAudiosButton)
        
        likedAudiosButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: likedAudiosButton, attribute: .bottom, relatedBy: .equal, toItem: self.rightLightImageView, attribute: .bottom, multiplier: 1, constant: -36).isActive = true
        
        NSLayoutConstraint(item: likedAudiosButton, attribute: .centerX, relatedBy: .equal, toItem: self.userProfileView, attribute: .centerX, multiplier: 1, constant: -90).isActive = true
        
        NSLayoutConstraint(item: likedAudiosButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
        
        NSLayoutConstraint(item: likedAudiosButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        likedAudiosButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        likedAudiosButton.tintColor = UIColor.hexStringToUIColor(hex: "#F1E6B9")
        
        likedAudiosButton.addTarget(self, action: #selector(selectLikedAudiosButton), for: .touchUpInside)
        
        self.view.addSubview(seeLikedAudiosButton)
        
        seeLikedAudiosButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: seeLikedAudiosButton, attribute: .top, relatedBy: .equal, toItem: likedAudiosButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: seeLikedAudiosButton, attribute: .centerX, relatedBy: .equal, toItem: likedAudiosButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: seeLikedAudiosButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: seeLikedAudiosButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        seeLikedAudiosButton.setTitle("See More", for: .normal)
        
        seeLikedAudiosButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#F1E6B9"), for: .normal)
        
        seeLikedAudiosButton.titleLabel?.font = UIFont(name: "American Typewriter", size: 14)
        
        seeLikedAudiosButton.addTarget(self, action: #selector(didTapSeeMoreLikedAudios), for: .touchUpInside)
    }
    
    @objc func selectMyAudiosButton() {
        
        if myAudiosButtonIsSelected == false {
            
            myAudiosButton.isSelected = true
            
            hideLeftLightBeam = false
            
            myAudiosButtonIsSelected = true
            
        } else {
            
            myAudiosButton.isSelected = false
            
            hideLeftLightBeam = true
            
            myAudiosButtonIsSelected = false
            
        }
        
    }
    
    @objc func didTapSeeMoreMyAudios() {
        
        let myAudioListViewController = MyAudioListViewController()
        myAudioListViewController.audios = myAudios
        self.navigationController?.pushViewController(myAudioListViewController, animated: true)
    }
       
    @objc func selectLikedAudiosButton() {
        
        if likedAudiosButtonIsSelected == false {
            
            likedAudiosButton.isSelected = true
            
            hideRightLightBeam = false
            
            likedAudiosButtonIsSelected = true
            
        } else {
            
            myAudiosButton.isSelected = false
            
            hideRightLightBeam = true
            
            likedAudiosButtonIsSelected = false
            
        }
        
    }
    
    @objc func didTapSeeMoreLikedAudios() {
        
        let myAudioListViewController = MyAudioListViewController()
        myAudioListViewController.audios = likedAudios
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
