//
//  DatabaseService.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import Foundation
import SQLite
import ComposableArchitecture
import Combine

final class DatabaseService {
    
    private let db: Connection
    
    struct Failure: Error, Equatable {}
    
    init(db: Connection) {
        self.db = db
    }
    
    func fetchCompany() -> Effect<[Company], Failure> {
        return Future<[Company], Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                var compnayList = [Company]()
                for row in try self.db.prepare(SQLQuery.allCompany.query) {
                    guard let name = row[0] as? String else { continue }
                    compnayList.append(Company(name: name))
                }
                promise(.success(compnayList))
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchLaunch() -> Effect<[Launch], Failure> {
        return Future<[Launch], Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                var launchList = [Launch]()
                for row in try self.db.prepare(SQLQuery.allLaunch.query) {
                    
                    guard let name = row[0] as? String else { continue }
                    guard let location = row[1] as? String else { continue }
                    guard let date = row[2] as? String else { continue }
                    guard let missionID = row[3] as? Int64 else { continue }
                    launchList.append(Launch(companyName: name, location: location, date: date, missionID: Int(missionID)))
                }
                promise(.success(launchList))
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchMission() -> Effect<[Mission], Failure> {
        return Future<[Mission], Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                var missionList = [Mission]()
                for row in try self.db.prepare(SQLQuery.allMission.query) {
                    
                    guard let missionID = row[0] as? Int64 else { continue }
                    guard let detail = row[1] as? String else { continue }
                    guard let statusRocket = row[2] as? String else { continue }
                    guard let statusMission = row[3] as? String else { continue }
                    guard let cost = row[4] as? String else { continue }
                    missionList.append(Mission(missionID: Int(missionID), detail: detail, statusRocket: statusRocket, cost: cost, statusMission: statusMission))
                }
                promise(.success(missionList))
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
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
    
    func queryAvgCost() {
        do {
            for row in try db.prepare(SQLQuery.highestAverageCostCreateView.query) {
                for col in row {
                    print(col)
                }
                
                print("")
            }
        }
        catch {
            print("View already exists")
            do {
                for row in try db.prepare(SQLQuery.highestAverageCost.query) {
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
