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
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 15) {
                Section {
                    Table(viewStore.companyList) {
                        TableColumn(Company.columnsName[0], value: \.companyName)
                    }
                } header: {
                    Text("Company")
                        .font(.headline)
                }
                .headerProminence(.increased)
                
                Section {
                    Table(viewStore.launchList) {
                        TableColumn(Launch.columnsName[0], value: \.companyName)
                        TableColumn(Launch.columnsName[1], value: \.location)
                        TableColumn(Launch.columnsName[2], value: \.date)
                        TableColumn(Launch.columnsName[3], value: \.mission)
                    }
                } header: {
                    Text("Launch")
                        .font(.headline)
                }
                .headerProminence(.increased)
                
                Section {
                    Table(viewStore.missionList) {
                        TableColumn(Mission.columnsName[0], value: \.mission)
                        TableColumn(Mission.columnsName[1], value: \.detail)
                        TableColumn(Mission.columnsName[2], value: \.statusRocket)
                        TableColumn(Mission.columnsName[3], value: \.statusMission)
                        TableColumn(Mission.columnsName[4], value: \.cost)
                    }
                } header: {
                    Text("Mission")
                        .font(.headline)
                }
                .headerProminence(.increased)

            }
            .padding(.vertical, 10)
            .onAppear {
                viewStore.send(.onAppearLoadCompany)
                viewStore.send(.onAppearLoadLaunch)
                viewStore.send(.onAppearLoadMission)
            }
        }
    }
}
