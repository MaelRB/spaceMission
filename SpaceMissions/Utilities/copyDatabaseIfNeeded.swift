//
//  CopyBundleFileToFileManager.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

// Move database file from bundle to documents folder
func getDatabaseFilePath() throws -> String {
//    Bundle.main.url(forResource: "SpaceMissions", withExtension: "sqlite")
    
    let fileManager = FileManager.default
    let documentsUrl = fileManager.urls(for: .documentDirectory,
                                           in: .userDomainMask)
    guard documentsUrl.count != 0 else {
        throw DatabaseError.documentUrlDoesNotExist
    }
    
    let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("SpaceMissions.sqlite")
    if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
        // DB doesn't exist in document folder, create it
        let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("SpaceMissions.sqlite")
        do {
            try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
        } catch let error as NSError {
            throw DatabaseError.couldNotCopy(error)
        }
    }
    
    return finalDatabaseURL.path
}
