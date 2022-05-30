//
//  PublishError.swift
//  Lightening
//
//  Created by claire on 2022/5/30.
//

enum PublishError: Error {
    
    case fetchAudiosError
    
    case fetchCommentsError
    
    case deleteAudioError
    
    var errorMessage: String {
        
        switch self {
            
        case .fetchAudiosError:
            return "Fail to fetch audios."
        
        case .fetchCommentsError:
            return "Fail to fetch comments."
            
        case .deleteAudioError:
            return "Fail to delete audio. Please try again."
            
        }
    }
}
