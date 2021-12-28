//
//  DatabaseError.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

enum DatabaseError: Error, LocalizedError {
    case unknownFilePath
    case documentUrlDoesNotExist
    case couldNotCopy(NSError)
    
    var errorDescription: String? {
        switch self {
            case .unknownFilePath:
                return "The database file path is incorrect"
            case .documentUrlDoesNotExist:
                return "Couldn't find document URL"
            case .couldNotCopy(let err):
                return "Couldn't copy file to final location! Error:\(err.description)"
        }
    }
}
