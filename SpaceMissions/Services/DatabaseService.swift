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
        queryRate()
    }
    
    func fetchCompany() {
        do {
            for row in try db.prepare(SQLQuery.allCompany.query) {
                for col in row {
                    print(col)
                }
                
                print("")
            }
        }
        catch {
            print(error)
        }
    }
    
    func queryRate() {
        do {
            for row in try db.prepare(SQLQuery.rateOfSuccessCreateView.query) {
                for col in row {
                    print(col)
                }
                
                print("")
            }
        }
        catch {
            print("View already exists")
            do {
                for row in try db.prepare(SQLQuery.rateOfSuccess.query) {
                    for col in row {
                        print(col)
                    }
                    
                    print("")
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    
}
