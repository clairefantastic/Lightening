//
//  UploadManager.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import Foundation

import FirebaseStorage

class UploadManager {
    
    func addAudio(audioUrl: URL) {
            // then lets create your document folder url
        audioUrl.startAccessingSecurityScopedResource()
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//
        let fileName = NSUUID().uuidString + ".m4a"
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
//            self.playMusic(url: destinationUrl)
        } else {

            do {

                // if the file doesn't exist you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else {
                    return
                }
                do {
                        // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
//                    self.playMusic(url: destinationUrl)
                    print("File moved to documents folder")
               
                    audioUrl.stopAccessingSecurityScopedResource()
                    
                    Storage.storage().reference().child("message_voice").child(fileName).putFile(from: destinationUrl.absoluteURL, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error ?? "error")
                        } else {
                            Storage.storage().reference().child("message_voice").child(fileName).downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                  // Uh-oh, an error occurred!
                                  return
                                }
                                print(downloadURL)
                            }
                        }
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                }).resume()
            }
        }
            

    
    }
    
}
