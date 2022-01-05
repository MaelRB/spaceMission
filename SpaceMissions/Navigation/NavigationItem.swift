//
//  NavigationItem.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import Foundation

enum NavigationItem: String {
    case menu = "Dashboard"
    case database = "Database"
    case company = "Company"
    case launch = "Launch"
    case mission = "Mission"
    
    var symbol: String {
        switch self {
            case .menu:
                return "list.bullet"
            case .database:
                return "opticaldiscdrive"
            default: return "opticaldiscdrive"
        }
    }
}
