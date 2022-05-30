//
//  PublishManager.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class PublishManager {
    
    static let shared = PublishManager()
    
    lazy var db = Firestore.firestore()
    
    func getSelectedFileLocalUrl(audioUrl: URL, completion: @escaping (URL)-> Void ) {
            // then lets create your document folder url
        audioUrl.startAccessingSecurityScopedResource()
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
        
        let fileName = NSUUID().uuidString + ".m4a"

            do {

                // if the file doesn't exist you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else {
                    return
                }
                do {
                    
//                    completion(destinationUrl)
                        // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    
                    completion(destinationUrl)
               
                    audioUrl.stopAccessingSecurityScopedResource()
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                }).resume()
            }
    
    }
    
    func getFileRemoteUrl(destinationUrl: URL, completion: @escaping (URL) -> Void ) {
        
        let fileName = NSUUID().uuidString + ".m4a"
        
        Storage.storage().reference().child("message_voice").child(fileName).putFile(from: destinationUrl.absoluteURL, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error ?? "error")
            } else {
                Storage.storage().reference().child("message_voice").child(fileName).downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                    completion(downloadURL)
                }
            }
        }
    }
    
    func publishAudioFile(audio: inout Audio, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let currentUser = UserManager.shared.currentUser else { return }
        
        let document = db.collection("audioFiles").document()
        audio.audioId = document.documentID
        audio.author = currentUser
        guard let authorId = currentUser.userId else { return }
        audio.authorId = authorId
        
        do {
            
           try document.setData(from: audio) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
            
        } catch {
            
            completion(.failure(error))
        }
     
    }
    
    func deleteAudio(audio: Audio, completion: @escaping (Result<(), Error>) -> Void) {
        
        let document = db.collection("audioFiles").document(audio.audioId)
        
        document.delete { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(()))
            }
        }
    }
    
    func fetchAudios(completion: @escaping (Result<[Audio], Error>) -> Void) {
        
        LKProgressHUD.show()
        
        db.collection("audioFiles").order(by: "createdTime", descending: true).addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            var audios = [Audio]()
            
            snapshot.documents.forEach { document in
                
                do {
                    if let audio = try document.data(as: Audio.self, decoder: Firestore.Decoder()) {
                        audios.append(audio)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            completion(.success(audios))
        }
    }
    
    func fetchAudioID(audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {
        
        LKProgressHUD.show()
        
        db.collection("audioFiles").whereField("audioUrl", isEqualTo: audio.audioUrl.absoluteString).getDocuments { (querySnapshot, error) in
            
                if let error = error {
                    completion(.failure(error))
                    
                } else {
                    
                    completion(.success(querySnapshot!.documents[0].documentID))
                    
                }
        }
    }
    
    func fetchAudioComments(documentId: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        db.collection("audioFiles").document(documentId).collection("comments").order(by: "createdTime", descending: true).addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            var comments = [Comment]()
            
            snapshot.documents.forEach { document in
                
                do {
                    if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                        comments.append(comment)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            completion(.success(comments))
        }
    }

    func publishComments(documentId: String, comment: inout Comment, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let author = UserManager.shared.currentUser else { return }
        comment.authorId = author.userId
        comment.authorName = author.displayName
        comment.authorImage = author.image
        comment.createdTime = Date().timeIntervalSince1970
        
        let document = db.collection("audioFiles").document(documentId).collection("comments").document()
        
        do {
           try document.setData(from: comment) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        } catch {
            
        }
     
    }
    
    func publishLikedAudio(userId: String, audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {

        let document = db.collection("users").document(userId).collection("likedAudios").document(audio.audioId)
        
        do {
           try document.setData(from: audio) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        } catch {
            
        }

    }
    
    func deleteLikedAudio(userId: String, audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {

        let document = db.collection("users").document(userId).collection("likedAudios").document(audio.audioId)

           document.delete { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
        
    func fetchLikedAudios(userId: String, completion: @escaping (Result<[Audio], Error>) -> Void) {
        
        LKProgressHUD.show()
        
        db.collection("users").document(userId).collection("likedAudios").addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            var likedAudios = [Audio]()
            
            snapshot.documents.forEach { document in
                do {
                    if let likedAudio = try document.data(as: Audio.self, decoder: Firestore.Decoder()) {
                        likedAudios.append(likedAudio)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            completion(.success(likedAudios))
        }
    }
    
    func getProfilePhotoUrl(selectedImage: UIImage) {
        
        let uniqueString = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("ProfilePhoto").child("\(uniqueString).png")
        
        if let uploadData = selectedImage.jpegData(compressionQuality: 0.5) {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    
                } else {

                    storageRef.downloadURL(completion: { url, error in
                        
                        guard let url = url else { return }
                        
                        self.publishProfilePhoto(url: url) { result in
                            
                            switch result {
                                
                            case .success:
                                print("success")
                            case .failure:
                                print("fail")
                            }
                        }
                        
                    })
                }
            }
        }

    }
    
    func publishProfilePhoto(url: URL, completion: @escaping (Result<String, Error>) -> Void) {

        guard var currentUser = UserManager.shared.currentUser else { return }
        
        currentUser.image = url
        
        guard let userId = currentUser.userId else { return }
        
        let document = db.collection("users").document("\(userId)")
        
        do {
            
           try document.setData(from: currentUser) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
            
        } catch {
            
        }
    }
    
    func publishName(name: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        LKProgressHUD.show()

        guard let currentUser = UserManager.shared.currentUser else { return }
        
        guard let userId = currentUser.userId else { return }
        
        let document = db.collection("users").document("\(userId)")
            
            try document.updateData(["displayName" : name]) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
    }
}
