//
//  PublishError.swift
//  Lightening
//
//  Created by claire on 2022/5/30.
//

enum PublishError: Error {
    
    case deleteAudioError
    
    var errorMessage: String {
        
        switch self {
            
        case .deleteAudioError:
            return "Fail to delete audio. Please try again."
            
        }
    }
}

