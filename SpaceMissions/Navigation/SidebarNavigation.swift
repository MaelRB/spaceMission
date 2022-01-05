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
    
    var body: some View {
        WithViewStore(self.store.stateless) { _ in
            NavigationView {
                List {
                    NavigationLink(tag: NavigationItem.menu, selection: $selection) {
                        MenuView(store: store.scope(state: \.menuState, action: RootAction.menuAction))
                            .toolbar {
                                Text("Info")
                            }
                    } label: {
                        Label("Menu", systemImage: NavigationItem.menu.symbol)
                    }
                    
                    DisclosureGroup {
                        NavigationLink(tag: NavigationItem.company, selection: $selection) {
                            DatabaseView(store: store.scope(state: \.databaseState, action: RootAction.databaseAction), databaseTable: .Company)
                                .toolbar {
                                    Text("Info")
                                }
                        } label: {
                            Text(NavigationItem.company.rawValue)
                        }
                        
                        NavigationLink(tag: NavigationItem.launch, selection: $selection) {
                            DatabaseView(store: store.scope(state: \.databaseState, action: RootAction.databaseAction), databaseTable: .Launch)
                                .toolbar {
                                    Text("Info")
                                }
                        } label: {
                            Text(NavigationItem.launch.rawValue)
                        }
                        
                        NavigationLink(tag: NavigationItem.mission, selection: $selection) {
                            DatabaseView(store: store.scope(state: \.databaseState, action: RootAction.databaseAction), databaseTable: .Mission)
                                .toolbar {
                                    Text("Info")
                                }
                        } label: {
                            Text(NavigationItem.mission.rawValue)
                        }
                    } label: {
                        Label(NavigationItem.database.rawValue, systemImage: NavigationItem.database.symbol)
                    }
                }
                .padding(.top, 10)
                .navigationTitle("SpaceMissions")
                
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
