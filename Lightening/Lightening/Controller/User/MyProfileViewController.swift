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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVinylImageView()
        addUserProfileView()
        ElementsStyle.styleViewBackground(userProfileView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.userProfileView.addGestureRecognizer(tapGestureRecognizer)
        self.userProfileView.imageUrl = UserManager.shared.currentUser?.image?.absoluteString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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

