//
//  AccountError.swift
//  Lightening
//
//  Created by claire on 2022/5/26.
//

enum AccountError: Error {
    
    case accountGeneralError
    
    case signInWithAppleError
    
    case registerVolunteerError
    
    case registerImpairedError
    
    case signOutError
    
    case getUserAudiosError
    
    case getAllAudiosError
    
    case getUserCommentsError
    
    case deleteUserAudiosError
    
    case deleteUserCommentsError
    
    case deleteUserDocumentError
    
    case deleteFirebaseUserError
    
    var errorMessage: String {
        
        switch self {
            
        case .accountGeneralError:
            return "Some error had happened. Please try again."
            
        case .signInWithAppleError:
            return "Fail to sign in with Apple. Please try again."
            
        case .registerVolunteerError:
            return "Fail to register as a volunteer. Please try again."
            
        case .registerImpairedError:
            return "Fail to register as a visually impaired user. Please try again."
            
        case .signOutError:
            return "Fail to sign out. Please try again."
            
        case .getUserAudiosError:
            return "Fail to get all uploaded audios by current user. Please try again."
            
        case .getAllAudiosError:
            return "Fail to get all uploaded audios. Please try again."
            
        case .getUserCommentsError:
            return "Fail to get all comments by current user. Please try again."
            
        case .deleteUserAudiosError:
            return "Fail to delete uploaded audios by current user. Please try again."
            
        case .deleteUserCommentsError:
            return "Fail to delete all comments by current user. Please try again."
            
        case .deleteUserDocumentError:
            return "Fail to delete user document. Please try again."
            
        case .deleteFirebaseUserError:
            return "Fail to delete Firebase user. Please try again."
            
        }
    }
}
