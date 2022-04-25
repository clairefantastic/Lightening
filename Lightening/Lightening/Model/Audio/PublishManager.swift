//
//  UploadManager.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

class PublishManager {
    
    static let shared = PublishManager()
    
    lazy var db = Firestore.firestore()
    
    var player: AVPlayer!
    
    func getSelectedFileLocalUrl(audioUrl: URL, completion: @escaping (URL)-> Void ) {
            // then lets create your document folder url
        audioUrl.startAccessingSecurityScopedResource()
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
        
        let fileName = NSUUID().uuidString + ".m4a"
//        if FileManager.default.fileExists(atPath: destinationUrl.path) {
//            print("The file already exists at path")
////            audiooPlayer?.play()
//        } else {

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

                    print("File moved to documents folder")
                    
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
                    print(downloadURL)
                }
            }
        }
    }
    
    func publishAudioFile(audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("audioFiles").document()
        
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
    
    func fetchAudioFiles(completion: @escaping (Result<[Audio], Error>) -> Void) {
        
        db.collection("audioFiles").order(by: "createdTime", descending: true).getDocuments() { (querySnapshot, error) in
            
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var audiofiles = [Audio]()
                    
                    for document in querySnapshot!.documents {

                        do {
                            if let audiofile = try document.data(as: Audio.self, decoder: Firestore.Decoder()) {
                                audiofiles.append(audiofile)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
//                            completion(.failure(FirebaseError.documentError))
                        }
                    }
                    
                    completion(.success(audiofiles))
                }
        }
    }
    
    func fetchAudioID(audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("audioFiles").whereField("audioUrl", isEqualTo: audio.audioUrl.absoluteString).getDocuments() { (querySnapshot, error) in
            
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    completion(.success(querySnapshot!.documents[0].documentID))
                    
                }
        }
    }
    
    func fetchAudioComments(documentId: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        db.collection("audioFiles").document(documentId).collection("comments").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var comments = [Comment]()
                
                for document in querySnapshot!.documents {

                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            comments.append(comment)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
//                            completion(.failure(FirebaseError.documentError))
                    }
                }
                
                completion(.success(comments))
            }
        }
    }
    
    
    func publishComments(documentId: String, comment: Comment, completion: @escaping (Result<String, Error>) -> Void) {
        
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
    
    func publishLikedAudio(authorId: String, audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {

        let document = db.collection("volunteers").document(authorId).collection("collections").document(audio.audioId ?? "")
        
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
    
    func deleteLikedAudio(authorId: String, audio: Audio, completion: @escaping (Result<String, Error>) -> Void) {

        let document = db.collection("volunteers").document(authorId).collection("collections").document(audio.audioId ?? "")

           document.delete() { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
    
    func fetchLikedAudio(userId: String, completion: @escaping (Result<[Audio], Error>) -> Void) {
        
        db.collection("volunteers").document(userId).collection("collections").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var likedAudios = [Audio]()
                
                for document in querySnapshot!.documents {

                    do {
                        if let likedAudio = try document.data(as: Audio.self, decoder: Firestore.Decoder()) {
                            likedAudios.append(likedAudio)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
//                            completion(.failure(FirebaseError.documentError))
                    }
                }
                
                completion(.success(likedAudios))
            }
        }
    }

    func playAudioFile(url: URL) {
        
        let asset = AVAsset(url: url)
        do {
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            player.volume = 100.0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
