//
//  RootFeature.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import ComposableArchitecture

struct RootState {
    var menuState = MenuState()
    var databaseState = DatabaseState()
    // Maps state
}

enum RootAction {
    case menuAction(MenuAction)
    case databaseAction(DatabaseAction)
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
        environment: { env in .init(databaseService: env.databaseService) }),
    databaseReducer.pullback(
        state: \.databaseState,
        action: /RootAction.databaseAction,
        environment: { env in .init(databaseService: env.databaseService) })
    )
// swiftlint:enable trailing_closure
