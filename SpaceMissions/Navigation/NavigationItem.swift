//
//  NavigationItem.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import Foundation

enum NavigationItem: String {
    case menu = "Menu"
    case database = "Database"
    case maps = "Maps"
    
    var symbol: String {
        switch self {
            case .menu:
                return "list.bullet"
            case .database:
                return "opticaldiscdrive"
            case .maps:
                return "map"
        }
    }
}
