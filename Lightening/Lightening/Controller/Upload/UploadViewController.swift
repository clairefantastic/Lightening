//
//  UploadViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/14.
//

import UIKit

import UniformTypeIdentifiers

import AVFoundation

import FirebaseStorage

class UploadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        layoutButton()
        
    }
    
    func layoutButton() {
        let selectFileButton = UIButton()
        
        self.view.addSubview(selectFileButton)
        
        selectFileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: selectFileButton, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 100).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: selectFileButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        selectFileButton.backgroundColor = .black
        
        selectFileButton.setTitle("Select File", for: .normal)
        
        selectFileButton.isEnabled = true
        
        selectFileButton.addTarget(self, action: #selector(importFile), for: .touchUpInside)
    }
    
    @objc func importFile(_ sender: UIButton) {
        
        var documentPicker: UIDocumentPickerViewController
        
        if #available(iOS 14.0, *) {
            
            let supportedTypes: [UTType] = [UTType.audio]
            
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        } else {
            
            documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: UIDocumentPickerMode.import)
        }
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        
        if let popoverController = documentPicker.popoverPresentationController {
            popoverController.sourceView = self.view
        }
    }
    
    
}

extension UploadViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        
        addAudio(audioUrl: url)
//            guard asset.isComposable else {
//                print("Your music is Not Composible")
//                return
//            }
            
    }
        
    func addAudio(audioUrl: URL) {
            // then lets create your document folder url
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
        
        print(destinationUrl)
        
        guard let fileUrl = URL(string: "\(destinationUrl)") else {
            return
        }
        
        let fileName = NSUUID().uuidString + ".m4a"
        
            Storage.storage().reference().child("message_voice").child(fileName).putFile(from: destinationUrl, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error ?? "error")
                }
        
        
//        let metadata = StorageMetadata()
//            metadata.contentType = "audio/m4a"
//            let riversRef = Storage.storage().reference().child("message_voice").child("go.m4a")
//            do {
//                let audioData = try Data(contentsOf: destinationUrl)
//                riversRef.putData(audioData, metadata: metadata){ (data, error) in
//                    if error == nil{
//                        debugPrint("se guardo el audio")
//                        riversRef.downloadURL {url, error in
//                            guard let downloadURL = url else { return }
//                            debugPrint("el url descargado", downloadURL)
//                        }
//                    }
//                    else {
//                        if let error = error?.localizedDescription{
//                            debugPrint("error al cargar imagen", error)
//                        }
//                        else {
//                            debugPrint("error de codigo")
//                        }
//                    }
//                }
//            } catch {
//                debugPrint(error.localizedDescription)
//            }
            
            
            
//           func getDirectory() -> URL {
//                    var tempPath = URL(fileURLWithPath: NSTemporaryDirectory())
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
//                    let stringDate = formatter.string(from: Date())
//                    tempPath.appendPathComponent(String.localizedStringWithFormat("output-%@.mp4", stringDate))
//                    return tempPath
//            }

            
//            // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
//            self.playMusic(url: destinationUrl)
        } else {
            
            do {
              
                // if the file doesn't exist you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                        // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
//                    self.playMusic(url: destinationUrl)
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
    }
    
//    func playMusic(url: URL) {
//        do {
//            let audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
    func handleAudioSendWith(url: String) {
        guard let fileUrl = URL(string: url) else {
            return
        }
        let fileName = NSUUID().uuidString + ".m4a"

        Storage.storage().reference().child("message_voice").child(fileName).putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error ?? "error")
            }

//            if let downloadUrl = metadata?.downloadURL()?.absoluteString {
//                print(downloadUrl)
//                let values: [String : Any] = ["audioUrl": downloadUrl]
//                self.sendMessageWith(properties: values)
//            }
        }
    }
}



}
}
