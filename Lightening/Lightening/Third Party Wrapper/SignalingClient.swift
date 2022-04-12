//
//  SignalingClient.swift
//  Lightening
//
//  Created by claire on 2022/4/11.
//

import Foundation
import WebRTC
import Firebase

protocol SignalClientDelegate: AnyObject {
  func signalClientDidConnect(_ signalClient: SignalingClient)
  func signalClientDidDisconnect(_ signalClient: SignalingClient)
  func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, didReceiveSender sender: String?)
  func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate)
}

final class SignalingClient {
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  weak var delegate: SignalClientDelegate?

  init() {

  }

  var getVolunteerHandler : ((String) -> Void)?

  func deleteSdpAndCandidateAndSender(for person: String) {
      Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("sdp").delete() { err in
      if let err = err {
        print("Error removing firestore sdp: \(err)")
      } else {
        print("Firestore sdp successfully removed!")
      }
    }

      Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("candidate").collection("candidates").getDocuments { (querySnapshot, err)  in
      if let err = err {
        print("Error removing firestore candidate: \(err)")
      } else {
          guard let querySnapshot = querySnapshot else { return }
          for document in querySnapshot.documents {
            print("Deleting \(document.documentID) => \(document.data())")
              document.reference.delete()
          }

      }
    }

      Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("sender").delete() { err in
      if let err = err {
        print("Error removing firestore sender: \(err)")
      } else {
        print("Firestore sender successfully removed!")
      }
    }
  }

    func send(sdp rtcSdp: RTCSessionDescription, from sender: String, to person: String) {
    do {
      let dataMessage = try self.encoder.encode(SessionDescription(from: rtcSdp))
      let dict = try JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as! [String: Any]
      Firestore.firestore().collection("volunteers").document(person).collection(person).document("sdp").setData(dict) { (err) in
          Firestore.firestore().collection("volunteers").document(person).collection(person).document("sender").setData(["sender": sender])
        if let err = err {
          print("Error send sdp: \(err)")
        } else {
          print("Sdp sent!")
        }
      }
    }
    catch {
      debugPrint("Warning: Could not encode sdp: \(error)")
    }
  }

  func send(candidate rtcIceCandidate: RTCIceCandidate, to person: String) {
    do {
      let dataMessage = try self.encoder.encode(IceCandidate(from: rtcIceCandidate))
      let dict = try JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as! [String: Any]
        Firestore.firestore().collection("volunteers").document(person).collection(person)
        .document("candidate")
        .collection("candidates")
        .addDocument(data: dict) { (err) in
          if let err = err {
            print("Error send candidate: \(err)")
          } else {
            print("Candidate sent!")
          }
      }
    }
    catch {
      debugPrint("Warning: Could not encode candidate: \(error)")
    }
  }

    func listenVolunteers() {

        Firestore.firestore().collection("volunteers").getDocuments {
            (snapshot, err) in
            if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   let randomInt = Int.random(in: 0..<snapshot!.documents.count)
                   let volunteerName = snapshot!.documents[randomInt].documentID
                   self.getVolunteerHandler?(volunteerName)


               }
        }

    }


  func listenSdp(to person: String) {
    Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("sdp")
      .addSnapshotListener { documentSnapshot, error in
        guard let document = documentSnapshot else {
          print("Error fetching sdp: \(error!)")
          return
        }
        guard let data = document.data() else {
          print("Firestore sdp data was empty.")
          return
        }
        print("Firestore sdp data: \(data)")
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
          let sessionDescription = try self.decoder.decode(SessionDescription.self, from: jsonData)
            self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription, didReceiveSender: nil)
          Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("sender")
              .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                  print("Error fetching sender: \(error!)")
                  return
                }
                  guard document.data() != nil else {
                  print("Firestore sender data was empty.")
                  return
                }
            do {
                print(document.data() ?? "")
                self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription, didReceiveSender: document.data()?["sender"] as? String)
            }
          }
       }
        catch {
          debugPrint("Warning: Could not decode sdp data: \(error)")
          return
        }
    }
  }

  func listenCandidate(to person: String) {
    Firestore.firestore()
      .collection("visuallyImpaired").document(person).collection(person)
      .document("candidate")
      .collection("candidates")
      .addSnapshotListener { (querySnapshot, err) in
        guard let documents = querySnapshot?.documents else {
          print("Error fetching documents: \(err!)")
          return
        }

        querySnapshot!.documentChanges.forEach { diff in
          if (diff.type == .added) {
            do {
              let jsonData = try JSONSerialization.data(withJSONObject: documents.first!.data(), options: .prettyPrinted)
              let iceCandidate = try self.decoder.decode(IceCandidate.self, from: jsonData)
              self.delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
            }
            catch {
              debugPrint("Warning: Could not decode candidate data: \(error)")
              return
            }
          }
        }


    }
  }
}







//final class SignalingClient {
//  private let decoder = JSONDecoder()
//  private let encoder = JSONEncoder()
//  weak var delegate: SignalClientDelegate?
//
//  init() {
//
//  }
//
//
//
//  func deleteSdpAndCandidateAndSender(for person: String) {
//      Firestore.firestore().collection("volunteers").document(person).collection(person).document("sdp").delete() { err in
//      if let err = err {
//        print("Error removing firestore sdp: \(err)")
//      } else {
//        print("Firestore sdp successfully removed!")
//      }
//    }
//
//
//
//      Firestore.firestore().collection("volunteers").document(person).collection(person).document("candidate").collection("candidates").getDocuments { (querySnapshot, err)  in
//      if let err = err {
//        print("Error removing firestore candidate: \(err)")
//      } else {
//          guard let querySnapshot = querySnapshot else { return }
//          for document in querySnapshot.documents {
//            print("Deleting \(document.documentID) => \(document.data())")
//            document.reference.delete()
//          }
//
//      }
//    }
//
//      Firestore.firestore().collection("volunteers").document(person).collection(person).document("sender").delete() { err in
//      if let err = err {
//        print("Error removing firestore sender: \(err)")
//      } else {
//        print("Firestore sender successfully removed!")
//      }
//    }
//  }
//
//    func send(sdp rtcSdp: RTCSessionDescription, from sender: String, to person: String) {
//    do {
//      let dataMessage = try self.encoder.encode(SessionDescription(from: rtcSdp))
//      let dict = try JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as! [String: Any]
//      Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("sdp").setData(dict) { (err) in
//          Firestore.firestore().collection("visuallyImpaired").document(person).collection(person).document("sender").setData(["sender": sender])
//        if let err = err {
//          print("Error send sdp: \(err)")
//        } else {
//          print("Sdp sent!")
//        }
//      }
//    }
//    catch {
//      debugPrint("Warning: Could not encode sdp: \(error)")
//    }
//  }
//
//  func send(candidate rtcIceCandidate: RTCIceCandidate, to person: String) {
//    do {
//      let dataMessage = try self.encoder.encode(IceCandidate(from: rtcIceCandidate))
//      let dict = try JSONSerialization.jsonObject(with: dataMessage, options: .allowFragments) as! [String: Any]
//        Firestore.firestore().collection("visuallyImpaired").document(person).collection(person)
//        .document("candidate")
//        .collection("candidates")
//        .addDocument(data: dict) { (err) in
//          if let err = err {
//            print("Error send candidate: \(err)")
//          } else {
//            print("Candidate sent!")
//          }
//      }
//    }
//    catch {
//      debugPrint("Warning: Could not encode candidate: \(error)")
//    }
//  }
//
//
//  func listenSdp(to person: String) {
//    Firestore.firestore().collection("volunteers").document(person).collection(person).document("sdp")
//      .addSnapshotListener { documentSnapshot, error in
//        guard let document = documentSnapshot else {
//          print("Error fetching sdp: \(error!)")
//          return
//        }
//        guard let data = document.data() else {
//          print("Firestore sdp data was empty.")
//          return
//        }
//        print("Firestore sdp data: \(data)")
//        do {
//          let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//          let sessionDescription = try self.decoder.decode(SessionDescription.self, from: jsonData)
//            self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription, didReceiveSender: nil)
//          Firestore.firestore().collection("volunteers").document(person).collection(person).document("sender")
//              .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                  print("Error fetching sender: \(error!)")
//                  return
//                }
//                  guard document.data() != nil else {
//                  print("Firestore sender data was empty.")
//                  return
//                }
//            do {
//                print(document.data() ?? "")
//                self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription, didReceiveSender: document.data()?["sender"] as? String)
//            }
//          }
//       }
//        catch {
//          debugPrint("Warning: Could not decode sdp data: \(error)")
//          return
//        }
//    }
//  }
//
//  func listenCandidate(to person: String) {
//    Firestore.firestore()
//      .collection("volunteers").document(person).collection(person)
//      .document("candidate")
//      .collection("candidates")
//      .addSnapshotListener { (querySnapshot, err) in
//        guard let documents = querySnapshot?.documents else {
//          print("Error fetching documents: \(err!)")
//          return
//        }
//
//        querySnapshot!.documentChanges.forEach { diff in
//          if (diff.type == .added) {
//            do {
//              let jsonData = try JSONSerialization.data(withJSONObject: documents.first!.data(), options: .prettyPrinted)
//              let iceCandidate = try self.decoder.decode(IceCandidate.self, from: jsonData)
//              self.delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
//            }
//            catch {
//              debugPrint("Warning: Could not decode candidate data: \(error)")
//              return
//            }
//          }
//        }
//    }
//  }
//}
//