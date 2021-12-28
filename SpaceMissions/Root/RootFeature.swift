//
//  RootFeature.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import ComposableArchitecture

struct RootState {
    var menuState = MenuState()
    // Database state
    // Maps state
}

enum RootAction {
    case menuAction(MenuAction)
    case databaseAction
    case mapsAction
}

struct RootEnvironment {
    let databaseService: DatabaseService
}


// swiftlint:disable trailing_closure
let rootReducer = Reducer<
    RootState,
    RootAction,
    RootEnvironment
>.combine(
    menuReducer.pullback(
        state: \.menuState,
        action: /RootAction.menuAction,
        environment: { _ in .init() })
    )
// swiftlint:enable trailing_closure
