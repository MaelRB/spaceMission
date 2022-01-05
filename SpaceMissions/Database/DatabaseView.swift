//
//  DatabaseView.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 03/01/2022.
//

import SwiftUI
import ComposableArchitecture

struct DatabaseView: View {
    
    let store: Store<DatabaseState, DatabaseAction>
    var databaseTable: DatabaseTable
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            databaseTable.tableView(store: viewStore)
                .padding(.vertical, 10)
                .onAppear {
                    viewStore.send(databaseTable.loadTableAction)
                }
                .navigationTitle(databaseTable.rawValue)
        }
    }
}

extension DatabaseView {
    enum DatabaseTable: String {
        case Company
        case Launch
        case Mission
        
        var loadTableAction: DatabaseAction {
            switch self {
                case .Company:  return .onAppearLoadCompany
                case .Launch:   return .onAppearLoadLaunch
                case .Mission:  return .onAppearLoadMission
            }
        }
        
        func tableView(store: ViewStore<DatabaseState, DatabaseAction>) -> some View {
            Group {
                switch self {
                    case .Company:  CompanyTableView(companyTable: store.companyList)
                    case .Launch:   LaunchTableView(launchTable: store.launchList)
                    case .Mission:  MissionTableView(missionTable: store.missionList)
                }
            }
        }
    }
}

struct LaunchTableView: View {
    
    var launchTable: [Launch]
    
    var body: some View {
        Table(launchTable) {
            TableColumn(Launch.columnsName[0], value: \.companyName)
            TableColumn(Launch.columnsName[1], value: \.location)
            TableColumn(Launch.columnsName[2], value: \.date)
            TableColumn(Launch.columnsName[3], value: \.mission)
        }
    }
}

struct CompanyTableView: View {
    
    var companyTable: [Company]
    
    var body: some View {
        Table(companyTable) {
            TableColumn(Company.columnsName[0], value: \.companyName)
        }
    }
}

struct MissionTableView: View {
    
    var missionTable: [Mission]
    
    var body: some View {
        Table(missionTable) {
            TableColumn(Mission.columnsName[0], value: \.mission)
            TableColumn(Mission.columnsName[1], value: \.detail)
            TableColumn(Mission.columnsName[2], value: \.statusRocket)
            TableColumn(Mission.columnsName[3], value: \.statusMission)
            TableColumn(Mission.columnsName[4], value: \.cost)
        }
    }
}
