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
    case companyLoaded(Result<[Company], DatabaseService.Failure>)
    case launchLoaded(Result<[Launch], DatabaseService.Failure>)
    case missionLoaded(Result<[Mission], DatabaseService.Failure>)
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
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(DatabaseAction.companyLoaded)
            
        case .onAppearLoadLaunch:
            guard state.launchList.isEmpty else { return .none }
            return environment.databaseService.fetchLaunch()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(DatabaseAction.launchLoaded)
            
        case .onAppearLoadMission:
            guard state.missionList.isEmpty else { return .none }
            return environment.databaseService.fetchMission()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(DatabaseAction.missionLoaded)
            
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
    }
}
