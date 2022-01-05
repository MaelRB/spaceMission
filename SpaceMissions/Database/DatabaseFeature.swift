//
//  DatabaseFeature.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 03/01/2022.
//

import ComposableArchitecture

struct DatabaseState: Equatable {
    var companyList: [Company] = []
    var launchList: [Launch] = []
    var missionList: [Mission] = []
}

enum DatabaseAction: Equatable {
    case onAppearLoadCompany
    case onAppearLoadLaunch
    case onAppearLoadMission
    
    case loadCompany
    case loadLaunch
    case loadMission
    
    case companyLoaded(Result<[Company], DatabaseService.Failure>)
    case launchLoaded(Result<[Launch], DatabaseService.Failure>)
    case missionLoaded(Result<[Mission], DatabaseService.Failure>)
    
    case addCompany(String)
    case addCompanyResponse(Result<Bool, DatabaseService.Failure>)
    
    case addLaunch(Launch)
    case addLaunchResponse(Result<Bool, DatabaseService.Failure>)
    
    case addMission(Mission)
    case addMissionResponse(Result<Bool, DatabaseService.Failure>)
    
    case deleteCompany(String)
    case deleteResponse(Result<Bool, DatabaseService.Failure>)
}

struct DatabaseEnvironment {
    let databaseService: DatabaseService
}

let databaseReducer = Reducer<
    DatabaseState,
    DatabaseAction,
    DatabaseEnvironment
> { state, action, environment in
    switch action {
        case .onAppearLoadCompany:
            guard state.companyList.isEmpty else { return .none }
            return environment.databaseService.fetchCompany()
                .catchToEffectOnMain(DatabaseAction.companyLoaded)
            
        case .onAppearLoadLaunch:
            guard state.launchList.isEmpty else { return .none }
            return environment.databaseService.fetchLaunch()
                .catchToEffectOnMain(DatabaseAction.launchLoaded)
            
        case .onAppearLoadMission:
            guard state.missionList.isEmpty else { return .none }
            return environment.databaseService.fetchMission()
                .catchToEffectOnMain(DatabaseAction.missionLoaded)
            
        case .loadCompany:
            return environment.databaseService.fetchCompany()
                .catchToEffectOnMain(DatabaseAction.companyLoaded)
            
        case .loadLaunch:
            return environment.databaseService.fetchLaunch()
                .catchToEffectOnMain(DatabaseAction.launchLoaded)
            
        case .loadMission:
            return environment.databaseService.fetchMission()
                .catchToEffectOnMain(DatabaseAction.missionLoaded)
            
        case .deleteCompany(let name):
            state.companyList.removeAll { $0.id == name }
            return environment.databaseService.deleteCompany(with: name)
                .catchToEffectOnMain(DatabaseAction.deleteResponse)
        
        case .deleteResponse(_):
            return .none
            
        case .companyLoaded(let result):
            switch result {
            case .success(let companyList):
                state.companyList = companyList
            case .failure(let error):
                print(error)
            }
            return .none
            
        case .launchLoaded(let result):
            switch result {
                case .success(let launchList):
                    state.launchList = launchList
                case .failure(let error):
                    print(error)
            }
            return .none
            
        case .missionLoaded(let result):
            switch result {
                case .success(let missionList):
                    state.missionList = missionList
                case .failure(let error):
                    print(error)
            }
            return .none
        
        case .addCompany(let name):
            state.companyList.append(Company(name: name))
            return environment.databaseService.addCompany(with: name)
                .catchToEffectOnMain(DatabaseAction.addCompanyResponse)
        
        case .addCompanyResponse(let result):
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(error)
            }
            return .none
            
        case .addLaunch(let launch):
            state.launchList.append(launch)
            return environment.databaseService.addLaunch(with: launch)
                .catchToEffectOnMain(DatabaseAction.addLaunchResponse)
            
        case .addLaunchResponse(let result):
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(error)
            }
            return .none
            
        case .addMission(let mission):
            state.missionList.append(mission)
            return environment.databaseService.addMission(with: mission)
                .catchToEffectOnMain(DatabaseAction.addMissionResponse)
            
        case .addMissionResponse(let result):
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(error)
            }
            return .none
    }
}
