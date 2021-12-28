//
//  Mission.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

struct Mission: Identifiable {
    
    let id: Int
    let missionID: Int
    let detail: String
    let statusRocket: String
    let statusMission: String
    let cost: String
    
    init(missionID: Int, detail: String, statusRocket: String, statusMission: String, cost: String) {
        self.id = missionID
        self.missionID = missionID
        self.detail = detail
        self.statusRocket = statusRocket
        self.statusMission = statusMission
        self.cost = cost
    }
}
