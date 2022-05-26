//
//  UserManager.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import UIKit
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

class UserManager {
    
    static let shared = UserManager()
    
    lazy var db = Firestore.firestore()
    
    fileprivate var currentNonce: String?
    
    var currentUser: User?
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        return request
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization, completion: @escaping (AuthDataResult?) -> Void) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                completion(authResult)
            }
        }
        
    }
    
    func registerAsVolunteer(name: String, user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = User(displayName: name, email: currentUser.email, userId: currentUser.uid, userIdentity: 1)
        
        let document = db.collection("users").document(currentUser.uid)
        
        do {
            try document.setData(from: user) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        } catch {
            
        }
    }
    
    func registerAsVisuallyImpaired(name: String, user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = User(displayName: name, email: currentUser.email, userId: currentUser.uid, userIdentity: 0)
        
        let document = db.collection("users").document(currentUser.uid)
        
        do {
            try document.setData(from: user) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        } catch {
            
        }
    }
    
    func register(with displayName: String, with email: String, with password: String, completion: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
            
            guard
                error == nil,
                let user = authDataResult?.user,
                let email = user.email,
                let self = self
                    
            else {
                
                completion(error)
                
                return
            }
            
            print("user registeration success! User: \(user.uid), \(user.email)")
            
            completion(nil)
            
        }
    }
    
    func nativeSignIn(with email: String, with password: String, completion: @escaping (Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            completion(error)
            
        }
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
            UserManager.shared.currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func fetchUserInfo(with userId: String, completion: @escaping (Result<User?, Error>) -> Void) {
        
        db.collection("users").whereField("userId", isEqualTo: userId).addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            var audios = [Audio]()
            
            snapshot.documents.forEach { document in
                
                do {
                    if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                        self.currentUser = user
                        completion(.success(self.currentUser))
                    } else {
                        completion(.success(nil))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
            
        }
    }
    
    func blockUser(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        LKProgressHUD.show()
        
        guard let currentUser = currentUser else {
            return
        }
        
        let document = db.collection("users").document(currentUser.userId ?? "")
        
        do {
            try document.updateData([
                "blockList": FieldValue.arrayUnion([userId])
            ]) { error in
                
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
    
    func deleteAccount(completion: @escaping (Result<(), Error>) -> Void) {
        
        LKProgressHUD.show()
        
        deleteUserAudios() { result in
            switch result {
                case .success:
                self.deleteUserComments() { result in
                    switch result {
                    case .success:
                        self.deleteUserDocument() { result in
                            switch result {
                            case .success:
                                Auth.auth().currentUser?.delete { error in
                                    if error == nil {
                                        completion(.success(()))
                                    } else {
                                        completion(.failure(DeleteAccountError.deleteFirebaseUserError))
                                    }
                                }
                                
                            case .failure:
                                completion(.failure(DeleteAccountError.deleteUserDocumentError))
                            }
                        }
                    case .failure:
                        completion(.failure(DeleteAccountError.deleteUserCommentsError))
                    }
                }
                case .failure:
                completion(.failure(DeleteAccountError.deleteUserAudiosError))
            }
        }
    }
    
    func deleteUserAudios(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let userId = UserManager.shared.currentUser?.userId else { return }
        
        self.db.collection("audioFiles").whereField("authorId", isEqualTo: userId).getDocuments() { (querySnapshot, error) in
            
            if error != nil {
                
                completion(.failure(DeleteAccountError.getUserAudiosError))
            } else {
                
                guard let documents = querySnapshot?.documents else { return }
    
                for document in documents {
                    document.reference.delete()
                }
                
                completion(.success("Successfully delete user audios."))
            }
        }
    }
    
    func deleteUserComments(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let userId = UserManager.shared.currentUser?.userId else { return }
        
        self.db.collection("audioFiles").getDocuments() { (querySnapshot, error) in
            
            if error != nil {
                
                completion(.failure(DeleteAccountError.getAllAudiosError))
                
            } else {
                
                guard let documents = querySnapshot?.documents else { return }
                
                let documentCount = documents.count
                
                var count = 0
                
                for document in documents {
                    
                    count += 1
                    
                    document.reference.collection("comments").whereField("authorId",
                                                                         isEqualTo: userId).getDocuments { (querySnapshot, error) in
                        
                        if error != nil {
                            
                            completion(.failure(DeleteAccountError.getUserCommentsError))
                        } else {
                            
                            guard let documents = querySnapshot?.documents else { return }
                            
                            for document in documents {
                                document.reference.delete()
                            }
                        }
                    }
                    
                    if count == documentCount {
                        
                        completion(.success("Successfully delete user comments."))
                    }
                }
            }
        }
    }
    
    func deleteUserDocument(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let userId = UserManager.shared.currentUser?.userId else { return }
        
        db.collection("users").document(userId).delete() { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Successfully delete user document."))
            }
        }
    }
}
