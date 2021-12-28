//
//  MenuFeature.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import ComposableArchitecture

struct MenuState: Equatable {
    
}

enum MenuAction: Equatable {
    
}

struct MenuEnvironment {
    
}

let menuReducer = Reducer<
    MenuState,
    MenuAction,
    MenuEnvironment
> { state, action, environment in
    return .none
}
