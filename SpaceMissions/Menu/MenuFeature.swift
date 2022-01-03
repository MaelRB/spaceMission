//
//  MenuFeature.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import ComposableArchitecture

struct MenuState: Equatable {
    var numberCompany: Int = 0
    var numberMission: Int = 0
    var numberMissionActive: Int = 0
    
    var totalCostQueryResult = ""
    var highestAvgCost = DatabaseService.HighestAvgResult(name: "", cost: 0)
    var totalCost: Double = 0.0
    
    var rateOfSuccess: Double = 0.0
    
    var companyList: [Company] = []
    var companyCompletion: [String] = []
    var companyCostQuery = ""
    var companyCost: Double = 0.0
}

enum MenuAction: Equatable {
    case onAppearGetNumberCompany
    case onAppearGetNumberMissionActive
    case onAppearGetHighestAvgCost
    case onAppearGetNumberMission
    case onAppearGetTotalCost
    case onAppearLoadCompany
    
    case highestAvgCostLoaded(Result<DatabaseService.HighestAvgResult, DatabaseService.Failure>)
    case numberCompanyLoaded(Result<Int, DatabaseService.Failure>)
    case numberMissionActiveLoaded(Result<Int, DatabaseService.Failure>)
    case numberMissionLoaded(Result<Int, DatabaseService.Failure>)
    case totalCostLoaded(Result<Double, DatabaseService.Failure>)
    case companyLoaded(Result<[Company], DatabaseService.Failure>)
    
    case companyCostQueryChanged(String)
    case companyCostCompletionResponse(Result<[String], Never>)
    case loadCompanyCost(String)
    case companyCostLoaded(Result<Double, DatabaseService.Failure>)
}

struct MenuEnvironment {
    let databaseService: DatabaseService
}

let menuReducer = Reducer<
    MenuState,
    MenuAction,
    MenuEnvironment
> { state, action, environment in
    switch action {
        case .onAppearLoadCompany:
            guard state.companyList.isEmpty else { return .none }
            return environment.databaseService.fetchCompany()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.companyLoaded)
            
        case .onAppearGetHighestAvgCost:
            return environment.databaseService.fetchHighestAvgCost()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.highestAvgCostLoaded)
            
        case .onAppearGetNumberCompany:
            return environment.databaseService.fetchNumberCompany()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.numberCompanyLoaded)
            
        case .onAppearGetNumberMissionActive:
            return environment.databaseService.fetchNumberMissionActive()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.numberMissionActiveLoaded)
        
        case .onAppearGetNumberMission:
            return environment.databaseService.fetchNumberMission()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.numberMissionLoaded)
            
        case .onAppearGetTotalCost:
            return environment.databaseService.fetchTotalCost()
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.totalCostLoaded)
            
        case .highestAvgCostLoaded(let result):
            switch result {
                case .success(let res):
                    state.highestAvgCost = res
                case .failure(let error):
                    print(error)
            }
            return .none
        
        case .numberCompanyLoaded(let result):
            switch result {
                case .success(let number):
                    state.numberCompany = number
                case .failure(let error):
                    print(error)
            }
            return .none
        
        case .numberMissionActiveLoaded(let result):
            switch result {
                case .success(let number):
                    state.numberMissionActive = number
                case .failure(let error):
                    print(error)
            }
            return .none
        
        case .numberMissionLoaded(let result):
            switch result {
                case .success(let number):
                    state.numberMission = number
                case .failure(let error):
                    print(error)
            }
            return .none
            
        case .totalCostLoaded(let result):
            switch result {
                case .success(let number):
                    state.totalCost = number
                case .failure(let error):
                    print(error)
            }
            return .none
            
        case .companyLoaded(let result):
            switch result {
                case .success(let companyList):
                    state.companyList = companyList
                case .failure(let error):
                    print(error)
            }
            return .none
            
        case .companyCostQueryChanged(let query):
            
            guard !state.companyList.map({ $0.companyName }).contains(query) else { return .none }
            
            func match(name: String, query: String) -> String? {
                let prefix = name.prefix(query.count)
                return  prefix.lowercased() == query.lowercased() ? name : nil
            }
            
            func keepFirst(_ n: Int, in array: [String]) -> [String] {
                return Array(array.prefix(n))
            }
            
            return state.companyList.publisher
                .map { $0.companyName }
                .compactMap { name in match(name: name, query: query) }
                .collect()
                .map { array in keepFirst(4, in: array) }
                .catchToEffect(MenuAction.companyCostCompletionResponse)
            
        case .companyCostCompletionResponse(let result):
            switch result {
                case .success(let completion):
                    state.companyCompletion = completion
                case .failure(let error):
                    state.companyCompletion = []
            }
            return .none
            
        case .loadCompanyCost(let name):
            state.companyCostQuery = name
            let index = state.companyList.firstIndex(of: Company(name: name))
            guard let safeIndex = index else { return .none }
            return environment.databaseService.fetchTotalCostForComapny(name: state.companyList[safeIndex].companyName)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.companyCostLoaded)
        
        case .companyCostLoaded(let result):
            state.companyCompletion.removeAll()
            switch result {
                case .success(let cost):
                    state.companyCost = cost
                case .failure(let error):
                    print(error)
            }
            return .none
    }
}
