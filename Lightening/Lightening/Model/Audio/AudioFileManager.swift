//
//  AudioFileManager.swift
//  Lightening
//
//  Created by claire on 2022/4/19.
//

import UIKit

enum FileExtension {
    case m4a
    case custom(String)
    
    var identifier: String {
        switch self {
        case .m4a: return "m4a"
        case .custom(let name): return name
        }
    }
}

struct AudioFileManager {

    private var filename: String
    private var fileExtension: FileExtension
    
    init(withFileName filename: String?, fileExtension: FileExtension = .m4a) {
        self.filename = filename ?? AudioFileManager.uniqeString()
        self.fileExtension = fileExtension
    }
    
    func fileUrl() -> URL {
        let filename = "\(self.filename).\(fileExtension.identifier)"
        let filePath = documentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    static func uniqeString() -> String {
        let timestamp = Date().timeIntervalSince1970
        return timestamp.description
    }
}

