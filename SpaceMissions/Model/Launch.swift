//
//  Launch.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

struct Launch: Identifiable, Equatable {
    
    let id: Int
    var companyName: String
    var location: String
    var date: String
    var missionID: Int
    
    var mission: String {
        return String(missionID)
    }
    
    init(companyName: String, location: String, date: String, missionID: Int) {
        self.id = missionID
        self.companyName = companyName
        self.location = location
        self.date = date
        self.missionID = missionID
    }
}

extension Launch {
    static let columnsName = ["companyName", "location", "date", "missionID"]
}
