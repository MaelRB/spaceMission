//
//  Company.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

struct Company: Identifiable, Equatable {
    
    let id: String
    let companyName: String
    
    init(name: String) {
        self.id = name
        self.companyName = name
    }
}

extension Company {
    static var columnsName = ["Name"]
}
