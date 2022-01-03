//
//  Launch.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

struct Launch: Identifiable, Equatable {
    
    let id: String
    let companyName: String
    let location: String
    let date: String
    let missionID: Int
    
    var mission: String {
        return String(missionID)
    }
    
    init(companyName: String, location: String, date: String, missionID: Int) {
        self.id = companyName
        self.companyName = companyName
        self.location = location
        self.date = date
        self.missionID = missionID
    }
}

extension Launch {
    static let columnsName = ["companyName", "location", "date", "missionID"]
}
