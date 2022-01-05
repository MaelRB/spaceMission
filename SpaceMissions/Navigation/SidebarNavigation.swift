//
//  SidebarNavigation.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import SwiftUI
import ComposableArchitecture

struct SidebarNavigation: View {
    
    let store: Store<RootState, RootAction>
    
    @State private var selection: NavigationItem? = .menu
    
    @State private var showInfoView = false
    
    var body: some View {
        WithViewStore(self.store.stateless) { _ in
            NavigationView {
                List {
                    NavigationLink(tag: NavigationItem.menu, selection: $selection) {
                        MenuView(store: store.scope(state: \.menuState, action: RootAction.menuAction))
                            .toolbarInfo(show: $showInfoView)
                    } label: {
                        Label("Menu", systemImage: NavigationItem.menu.symbol)
                    }
                    
                    DisclosureGroup {
                        NavigationLink(tag: NavigationItem.company, selection: $selection) {
                            DatabaseView(store: store.scope(state: \.databaseState, action: RootAction.databaseAction), databaseTable: .Company)
                                .toolbarInfo(show: $showInfoView)
                        } label: {
                            Text(NavigationItem.company.rawValue)
                        }
                        
                        NavigationLink(tag: NavigationItem.launch, selection: $selection) {
                            DatabaseView(store: store.scope(state: \.databaseState, action: RootAction.databaseAction), databaseTable: .Launch)
                                .toolbarInfo(show: $showInfoView)
                        } label: {
                            Text(NavigationItem.launch.rawValue)
                        }
                        
                        NavigationLink(tag: NavigationItem.mission, selection: $selection) {
                            DatabaseView(store: store.scope(state: \.databaseState, action: RootAction.databaseAction), databaseTable: .Mission)
                                .toolbarInfo(show: $showInfoView)
                        } label: {
                            Text(NavigationItem.mission.rawValue)
                        }
                    } label: {
                        Label(NavigationItem.database.rawValue, systemImage: NavigationItem.database.symbol)
                    }
                }
                .padding(.top, 10)
                .navigationTitle("SpaceMissions")
                .sheet(isPresented: $showInfoView, onDismiss: nil) {
                    InfoView()
                }
                
                Text("Select a category")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background()
                    .ignoresSafeArea()
            }
            .frame(minWidth: 800, idealWidth: 1000, minHeight: 400, idealHeight: 600, alignment: .center)
        }
    }

}
