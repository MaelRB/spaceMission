//
//  MenuFeature.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import ComposableArchitecture

// MARK: - State
struct MenuState: Equatable {
    
    // Company
    var numberCompany: Int = 0
    var rateOfSuccess: Double = 0.0
    var rateOfSuccessSearchCompletion: [String] = []
    var rateOfSuccessSearchQuery = ""
    
    // Mission
    var numberMission: Int = 0
    var numberMissionActive: Int = 0
    var numberMissionForCompany: Int = 0
    var missionSearchCompletion: [String] = []
    var missionSearchQuery = ""
    
    // Cost
    var totalCostQueryResult = ""
    var highestAvgCost = DatabaseService.HighestAvgResult(name: "", cost: 0)
    var totalCost: Double = 0.0
    var costSearchCompletion: [String] = []
    var costQuery = ""
    var costForCompany: Double = 0.0
    
    var companyList: [Company] = []
}

// MARK: - Action

enum MenuAction: Equatable {
    
    case onAppear
    
    // Company
    case companyLoaded(Result<[Company], DatabaseService.Failure>)
    case numberCompanyLoaded(Result<Int, DatabaseService.Failure>)
    
    case companyQueryChanged(String)
    case companyCompletionResponse(Result<[String], Never>)
    case loadRateOfSuccess(String)
    case rateOfSuccessLoaded(Result<Double, DatabaseService.Failure>)
    
    // Mission
    case numberMissionActiveLoaded(Result<Int, DatabaseService.Failure>)
    case numberMissionLoaded(Result<Int, DatabaseService.Failure>)
    
    case missionQueryChanged(String)
    case missionCompletionResponse(Result<[String], Never>)
    case loadNumberMission(String)
    case numberMissionForCompanyLoaded(Result<Int, DatabaseService.Failure>)
    
    // Cost
    case highestAvgCostLoaded(Result<DatabaseService.HighestAvgResult, DatabaseService.Failure>)
    case totalCostLoaded(Result<Double, DatabaseService.Failure>)
    
    case companyCostQueryChanged(String)
    case companyCostCompletionResponse(Result<[String], Never>)
    case loadCompanyCost(String)
    case companyCostLoaded(Result<Double, DatabaseService.Failure>)
    
}

// MARK: - Environment

struct MenuEnvironment {
    let databaseService: DatabaseService
}

// MARK: - Reducer

let menuReducer = Reducer<
    MenuState,
    MenuAction,
    MenuEnvironment
> { state, action, environment in
    switch action {
            
        // onAppear
        
        case .onAppear:
            return .merge(
                environment.databaseService.fetchCompany()
                    .catchToEffectOnMain(MenuAction.companyLoaded),
                
                environment.databaseService.fetchHighestAvgCost()
                    .catchToEffectOnMain(MenuAction.highestAvgCostLoaded),
                
                environment.databaseService.fetchNumberCompany()
                    .catchToEffectOnMain(MenuAction.numberCompanyLoaded),
                
                environment.databaseService.fetchNumberMissionActive()
                    .catchToEffectOnMain(MenuAction.numberMissionActiveLoaded),
                
                environment.databaseService.fetchNumberMission()
                    .catchToEffectOnMain(MenuAction.numberMissionLoaded),
                
                environment.databaseService.fetchTotalCost()
                    .catchToEffectOnMain(MenuAction.totalCostLoaded)
            )
            
        // Company
            
        case .numberCompanyLoaded(let result):
            switch result {
                case .success(let number):
                    state.numberCompany = number
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
            
        case .companyQueryChanged(let query):
            guard !state.companyList.map({ $0.companyName }).contains(query) else { return .none }
            
            return state.companyList.publisher
                .map { $0.companyName }
                .compactMap { name in MenuReducerHelper.match(name: name, query: query) }
                .collect()
                .map { array in MenuReducerHelper.keepFirst(4, in: array) }
                .catchToEffect(MenuAction.companyCompletionResponse)
            
        case .companyCompletionResponse(let result):
            switch result {
                case .success(let completion):
                    state.rateOfSuccessSearchCompletion = completion
                case .failure(let error):
                    state.rateOfSuccessSearchCompletion = []
            }
            return .none
            
        case .loadRateOfSuccess(let name):
            state.rateOfSuccessSearchQuery = name
            let index = state.companyList.firstIndex(of: Company(name: name))
            guard let safeIndex = index else { return .none }
            return environment.databaseService.fetchRateOfSuccess(for: state.companyList[safeIndex].companyName)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.rateOfSuccessLoaded)
            
        case .rateOfSuccessLoaded(let result):
            state.rateOfSuccessSearchCompletion.removeAll()
            switch result {
                case .success(let number):
                    state.rateOfSuccess = number
                case .failure(let error):
                    print(error)
            }
            return .none
            
        // Mission
            
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
            
        case .missionQueryChanged(let query):
            guard !state.companyList.map({ $0.companyName }).contains(query) else { return .none }
            
            return state.companyList.publisher
                .map { $0.companyName }
                .compactMap { name in MenuReducerHelper.match(name: name, query: query) }
                .collect()
                .map { array in MenuReducerHelper.keepFirst(4, in: array) }
                .catchToEffect(MenuAction.missionCompletionResponse)
            
        case .missionCompletionResponse(let result):
            switch result {
                case .success(let completion):
                    state.missionSearchCompletion = completion
                case .failure(let error):
                    state.missionSearchCompletion = []
            }
            return .none
            
        case .loadNumberMission(let name):
            state.missionSearchQuery = name
            let index = state.companyList.firstIndex(of: Company(name: name))
            guard let safeIndex = index else { return .none }
            return environment.databaseService.fetchNumberMissionForComapny(name: state.companyList[safeIndex].companyName)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.numberMissionForCompanyLoaded)
            
        case .numberMissionForCompanyLoaded(let result):
            state.missionSearchCompletion.removeAll()
            switch result {
                case .success(let number):
                    state.numberMissionForCompany = number
                case .failure(let error):
                    print(error)
            }
            return .none
            
        // Cost
            
        case .highestAvgCostLoaded(let result):
            switch result {
                case .success(let res):
                    state.highestAvgCost = res
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
            
        case .companyCostQueryChanged(let query):
            
            guard !state.companyList.map({ $0.companyName }).contains(query) else { return .none }
            
            return state.companyList.publisher
                .map { $0.companyName }
                .compactMap { name in MenuReducerHelper.match(name: name, query: query) }
                .collect()
                .map { array in MenuReducerHelper.keepFirst(4, in: array) }
                .catchToEffect(MenuAction.companyCostCompletionResponse)
            
        case .companyCostCompletionResponse(let result):
            switch result {
                case .success(let completion):
                    state.costSearchCompletion = completion
                case .failure(let error):
                    state.costSearchCompletion = []
            }
            return .none
            
        case .loadCompanyCost(let name):
            state.costQuery = name
            let index = state.companyList.firstIndex(of: Company(name: name))
            guard let safeIndex = index else { return .none }
            return environment.databaseService.fetchTotalCostForComapny(name: state.companyList[safeIndex].companyName)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MenuAction.companyCostLoaded)
        
        case .companyCostLoaded(let result):
            state.costSearchCompletion.removeAll()
            switch result {
                case .success(let cost):
                    state.costForCompany = cost
                case .failure(let error):
                    print(error)
            }
            return .none
    }
}

struct MenuReducerHelper {
    
    static func match(name: String, query: String) -> String? {
        let prefix = name.prefix(query.count)
        return  prefix.lowercased() == query.lowercased() ? name : nil
    }
    
    static func keepFirst(_ n: Int, in array: [String]) -> [String] {
        return Array(array.prefix(n))
    }
    
}
