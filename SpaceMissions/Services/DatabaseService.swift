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
    
    private let defaults = UserDefaults.standard
    
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
    
    func fetchHighestAvgCost() -> Effect<HighestAvgResult, Failure> {
        return Future<HighestAvgResult, Failure> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                
                // Table view not created
                if self.defaults.bool(forKey: "isAverageViewCreated") == false {
                    self.defaults.set(true, forKey: "isAverageViewCreated")
                    do {
                        for _ in try self.db.prepare(SQLQuery.highestAverageCostCreateView.query) {}
                    } catch {}
                }
                
                for row in try self.db.prepare(SQLQuery.highestAverageCost.query) {
                    guard let name = row[0] as? String else { continue }
                    guard let cost = row[1] as? Double else { continue }
                    promise(.success(HighestAvgResult(name: name, cost: Double(cost))))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchNumberMissionActive() -> Effect<Int, Failure> {
        return Future<Int, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for row in try self.db.prepare(SQLQuery.numberMissionActive.query) {
                    guard let number = row[0] as? Int64 else { continue }
                    promise(.success(Int(number)))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchRateOfSuccess(for name: String) -> Effect<Double, Failure> {
        return Future<Double, Failure> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                
                // Table view not created
                if self.defaults.bool(forKey: "isSumViewCreated") == false {
                    self.defaults.set(true, forKey: "isSumViewCreated")
                    do {
                        for _ in try self.db.prepare(SQLQuery.rateOfSuccessCreateView.query) {}
                    } catch {}
                }
                
                for row in try self.db.prepare(SQLQuery.rateOfSuccess(name).query) {
                    guard let number = row[0] as? Double else { continue }
                    promise(.success(number))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchNumberCompany() -> Effect<Int, Failure> {
        return Future<Int, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for row in try self.db.prepare(SQLQuery.numberCompany.query) {
                    guard let number = row[0] as? Int64 else { continue }
                    promise(.success(Int(number)))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchNumberMission() -> Effect<Int, Failure> {
        return Future<Int, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for row in try self.db.prepare(SQLQuery.numberMission.query) {
                    guard let number = row[0] as? Int64 else { continue }
                    promise(.success(Int(number)))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchTotalCost() -> Effect<Double, Failure> {
        return Future<Double, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for row in try self.db.prepare(SQLQuery.totalCost.query) {
                    guard let number = row[0] as? Double else { continue }
                    promise(.success(number))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchTotalCostForComapny(name: String) -> Effect<Double, Failure> {
        return Future<Double, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for row in try self.db.prepare(SQLQuery.totalCostForCompany(name).query) {
                    guard let number = row[0] as? Double else { continue }
                    promise(.success(number))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func fetchNumberMissionForComapny(name: String) -> Effect<Int, Failure> {
        return Future<Int, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for row in try self.db.prepare(SQLQuery.numberMissionForCompany(name).query) {
                    guard let number = row[0] as? Int64 else { continue }
                    promise(.success(Int(number)))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func addCompany(with name: String) -> Effect<Bool, Failure> {
        return Future<Bool, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for _ in try self.db.prepare(SQLQuery.addCompany(name).query) {
                    promise(.success(true))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func addLaunch(with launch: Launch) -> Effect<Bool, Failure> {
        return Future<Bool, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for _ in try self.db.prepare(SQLQuery.addLaunch(launch).query) {
                    promise(.success(true))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func addMission(with mission: Mission) -> Effect<Bool, Failure> {
        return Future<Bool, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for _ in try self.db.prepare(SQLQuery.addMission(mission).query) {
                    promise(.success(true))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }
    
    func deleteCompany(with name: String) -> Effect<Bool, Failure> {
        return Future<Bool, Failure> { [weak self] promise in
            guard let self = self else { return }
            do {
                for _ in try self.db.prepare(SQLQuery.deleteCompany(name).query) {
                    promise(.success(true))
                }
            }
            catch {
                promise(.failure(Failure()))
            }
        }
        .eraseToEffect()
    }

}
