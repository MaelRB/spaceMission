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
    
    @State private var selection: NavigationItem?
    
    var body: some View {
        WithViewStore(self.store.stateless) { _ in
            NavigationView {
                List {
                    NavigationLink(tag: NavigationItem.menu, selection: $selection) {
                        MenuView()
                            .toolbar {
                                Text("Info")
                            }
                    } label: {
                        Label("Menu", systemImage: NavigationItem.menu.symbol)
                    }
                    
                    NavigationLink(tag: NavigationItem.database, selection: $selection) {
                        Text(NavigationItem.database.rawValue)
                            .toolbar {
                                Text("Info")
                            }
                    } label: {
                        Label("Database", systemImage: NavigationItem.database.symbol)
                    }
                    
                    NavigationLink(tag: NavigationItem.maps, selection: $selection) {
                        Text(NavigationItem.maps.rawValue)
                            .toolbar {
                                Text("Info")
                            }
                    } label: {
                        Label("Maps", systemImage: NavigationItem.maps.symbol)
                    }
                }
                .navigationTitle("SpaceMissions")
                
                Text("Select a category")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background()
                    .ignoresSafeArea()
            }
        }
    }
}
