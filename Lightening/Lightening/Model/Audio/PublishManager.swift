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

