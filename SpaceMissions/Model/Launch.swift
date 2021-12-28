//
//  Launch.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

struct Launch: Identifiable {
    
    let id: String
    let companyName: String
    let location: String
    let date: String
    let missionID: Int
    
    init(companyName: String, location: String, date: String, missionID: Int) {
        self.id = companyName
        self.companyName = companyName
        self.location = location
        self.date = date
        self.missionID = missionID
    }
}
