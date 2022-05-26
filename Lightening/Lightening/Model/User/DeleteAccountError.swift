//
//  DeleteAccountError.swift
//  Lightening
//
//  Created by claire on 2022/5/26.
//

enum DeleteAccountError: Error {
    
    case getUserAudiosError
    
    case getAllAudiosError
    
    case getUserCommentsError
    
    case deleteUserAudiosError
    
    case deleteUserCommentsError
    
    case deleteUserDocumentError
    
    case deleteFirebaseUserError
    
    var errorMessage: String {
        
        switch self {
            
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

