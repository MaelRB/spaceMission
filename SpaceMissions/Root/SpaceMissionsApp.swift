//
//  SpaceMissionsApp.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import SwiftUI
import ComposableArchitecture

@main
struct SpaceMissionsApp: App {
    var body: some Scene {
        WindowGroup {
            SidebarNavigation(store: Store(initialState: RootState(), reducer: rootReducer, environment: RootEnvironment()))
        }
    }
}
