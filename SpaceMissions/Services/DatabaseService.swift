//
//  DatabaseService.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import Foundation
import SQLite

final class DatabaseService {
    
    private let db: Connection
    
    init(db: Connection) {
        self.db = db
        fetchCompany()
    }
    
    func fetchCompany() {
        do {
            for row in try db.prepare("SELECT * FROM Company") {
                print("companyName: \(row[0])")
            }
        }
        catch {
            print(error)
        }
    }
    
    
}
