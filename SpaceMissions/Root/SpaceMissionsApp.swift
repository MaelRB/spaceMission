//
//  SpaceMissionsApp.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import SwiftUI
import ComposableArchitecture
import SQLite

@main
struct SpaceMissionsApp: App {
    
    private let databaseFilePath = Bundle.main.url(forResource: "SpaceMissions", withExtension: "sqlite")
    
    var error: Error?
    let database: Connection?
    
    enum DatabaseError: Error, LocalizedError {
        case unknownFilePath
        
        var errorDescription: String? {
            switch self {
                case .unknownFilePath:
                    return "The database file path is incorrect"
            }
        }
    }
    
    init() {
        do {
            guard let databaseFilePath = databaseFilePath else { throw DatabaseError.unknownFilePath }
            database = try Connection(databaseFilePath.absoluteString)
        }
        catch {
            database = nil
            self.error = error
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            if let database = database {
                SidebarNavigation(store: Store(initialState: RootState(), reducer: rootReducer, environment: RootEnvironment(databaseService: DatabaseService(db: database))))
            } else {
                ErrorView(error: error!)
            }
        }
    }
}
