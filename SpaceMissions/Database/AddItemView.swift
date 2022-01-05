//
//  AddItemView.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 05/01/2022.
//

import SwiftUI
import class SQLite.Connection
import ComposableArchitecture

struct AddItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var viewStore: ViewStore<DatabaseState, DatabaseAction>
    var table: DatabaseView.DatabaseTable
    
    var companyWrapper = CompanyWrapper()
    var launchWrapper = LaunchWrapper()
    var missionWrapper = MissionWrapper()
    
    init(viewStore: ViewStore<DatabaseState, DatabaseAction>, table: DatabaseView.DatabaseTable) {
        self.viewStore = viewStore
        self.table = table
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Add \(table.rawValue)")
                    .font(.headline)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.borderless)

            }
            
            Divider()
                .padding(.bottom, 10)
            
            content
                .padding(.bottom, 10)
            
            Button {
                withAnimation {
                    add()
                }
            } label: {
                Text("Add")
                    .padding(3)
            }
            .buttonStyle(.borderedProminent)

        }
        .padding(15)
        .frame(width: 300)
    }
    
    private func add() {
        switch table {
            case .Company:
                viewStore.send(.addCompany(companyWrapper.name))
            case .Launch:
                viewStore.send(.addLaunch(launchWrapper.launch))
            case .Mission:
                viewStore.send(.addMission(missionWrapper.mission))
        }
        dismiss()
    }
    
    var content: some View {
        Group {
            switch table {
                case .Company:
                    AddCompanyView(viewStore: viewStore, companyWrapper: companyWrapper)
                case .Launch:
                    AddLaunchView(viewStore: viewStore, launchWrapper: launchWrapper)
                case .Mission:
                    AddMissionView(viewStore: viewStore, missionWrapper: missionWrapper)
            }
        }
    }
    
}


struct AddItemView_Previews: PreviewProvider {
    

    static let viewStore = ViewStore(Store(initialState: DatabaseState(), reducer: databaseReducer, environment: DatabaseEnvironment(databaseService: DatabaseService(db: try! Connection()))))
    
    static var previews: some View {
        AddItemView(viewStore: viewStore, table: .Launch)
    }
}

struct AddCompanyView: View {
    
    var viewStore: ViewStore<DatabaseState, DatabaseAction>
    let companyWrapper: CompanyWrapper
    
    @State private var nameField = ""
    
    var body: some View {
        HStack {
            Text("Name: ")
            TextField("", text: $nameField)
                .textFieldStyle(.roundedBorder)
                .onChange(of: nameField) { newValue in
                    companyWrapper.name = newValue
                }
        }
    }
}

struct AddLaunchView: View {
    
    var viewStore: ViewStore<DatabaseState, DatabaseAction>
    let launchWrapper: LaunchWrapper
    
    @State private var companyNameField = ""
    @State private var locationField = ""
    @State private var dateField = ""
    @State private var missionIDField = ""
    
    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Company Name: ")
                Text("Location: ")
                Text("Date: ")
                Text("missionID: ")
            }
            
            VStack {
                TextField("", text: $companyNameField)
                    .onChange(of: companyNameField) { newValue in
                        launchWrapper.launch.companyName = newValue
                    }
                TextField("", text: $locationField)
                    .onChange(of: locationField) { newValue in
                        launchWrapper.launch.location = newValue
                    }
                TextField("", text: $dateField)
                    .onChange(of: dateField) { newValue in
                        launchWrapper.launch.date = newValue
                    }
                TextField("", text: $missionIDField)
                    .onChange(of: missionIDField) { newValue in
                        guard let intValue = Int(newValue) else { return }
                        launchWrapper.launch.missionID = intValue
                    }
            }
            .textFieldStyle(.roundedBorder)
        }
    }
}

struct AddMissionView: View {
    
    var viewStore: ViewStore<DatabaseState, DatabaseAction>
    let missionWrapper: MissionWrapper
    
    @State private var missionIDField = ""
    @State private var detailField = ""
    @State private var statusRocketField = ""
    @State private var costField = ""
    @State private var statusMissionField = ""
    
    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("missionID: ")
                Text("Detail: ")
                Text("Status rocket: ")
                Text("Cost (M$): ")
                Text("Status mission: ")
            }
            
            VStack {
                TextField("", text: $missionIDField)
                    .onChange(of: missionIDField) { newValue in
                        guard let intValue = Int(newValue) else { return }
                        missionWrapper.mission.missionID = intValue
                    }
                TextField("", text: $detailField)
                    .onChange(of: detailField) { newValue in
                        missionWrapper.mission.detail = newValue
                    }
                TextField("", text: $statusRocketField)
                    .onChange(of: statusRocketField) { newValue in
                        missionWrapper.mission.statusRocket = newValue
                    }
                TextField("", text: $costField)
                    .onChange(of: costField) { newValue in
                        missionWrapper.mission.cost = newValue
                    }
                TextField("", text: $statusMissionField)
                    .onChange(of: statusMissionField) { newValue in
                        missionWrapper.mission.statusMission = newValue
                    }
            }
            .textFieldStyle(.roundedBorder)
        }
    }
}

final class CompanyWrapper {
    var name: String = ""
}

final class LaunchWrapper {
    var launch: Launch = .init(companyName: "", location: "", date: "", missionID: 0)
}

final class MissionWrapper {
    var mission: Mission = .init(missionID: 0, detail: "", statusRocket: "", cost: "", statusMission: "")
}

