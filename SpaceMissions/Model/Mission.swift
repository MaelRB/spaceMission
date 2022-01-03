//
//  Mission.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

struct Mission: Identifiable, Equatable {

    let id: Int
    let missionID: Int
    let detail: String
    let statusRocket: String
    let cost: String
    let statusMission: String
    
    var mission: String {
        return String(missionID)
    }
    
    init(missionID: Int, detail: String, statusRocket: String, cost: String, statusMission: String) {
        self.id = missionID
        self.missionID = missionID
        self.detail = detail
        self.statusRocket = statusRocket
        self.statusMission = statusMission
        self.cost = cost
    }
}

extension Mission {
    static let columnsName = ["missionID", "detail", "statusRocket", "cost", "statusMission"]
}
