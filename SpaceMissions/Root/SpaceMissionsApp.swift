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
    
    var error: Error?
    let database: Connection?
    
    init() {
        do {
            let databaseFilePath = try getDatabaseFilePath()
            database = try Connection(databaseFilePath)
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
        .commands {
            SidebarCommands()
        }
    }
}
