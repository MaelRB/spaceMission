//
//  MenuView.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 27/12/2021.
//

import SwiftUI
import ComposableArchitecture

struct MenuView: View {
    
    let store: Store<MenuState, MenuAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 20) {
                        CardView(title: "Mission") {
                            Text("Number missions: \(viewStore.numberMission)")
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundColor(.green)
                                Text("Missions active: \(viewStore.numberMissionActive)")
                            }
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundColor(.red)
                                Text("Missions inactive: \(viewStore.numberMission - viewStore.numberMissionActive)")
                            }
                            
                            SearchField(title: "Number missions for a company", placeholder: "NASA, ESA, SpaceX...", query: viewStore.binding(get: \.missionSearchQuery, send: MenuAction.missionQueryChanged), completionResult: viewStore.missionSearchCompletion) { query in
                                viewStore.send(.loadNumberMission(query))
                            } completionAction: { completion in
                                viewStore.send(.loadNumberMission(completion))
                            } content: {
                                Text("Number missions: \(viewStore.numberMissionForCompany)")
                            }

                            
                        }
                        
                        CardView(title: "Cost") {
                            Text("Highest average cost: \(viewStore.highestAvgCost.name) | \(viewStore.highestAvgCost.cost, specifier: "%.2f") M$")
                            Text("Total cost: \(viewStore.totalCost, specifier: "%.2f") M$")
                            
                            SearchField(title: "Total cost for a company", placeholder: "NASA, ESA, SpaceX...", query: viewStore.binding(get: \.costQuery, send: MenuAction.companyCostQueryChanged), completionResult: viewStore.costSearchCompletion) { query in
                                viewStore.send(.loadCompanyCost(query))
                            } completionAction: { completion in
                                viewStore.send(.loadCompanyCost(completion))
                            } content: {
                                Text("Total cost: \(viewStore.costForCompany, specifier: "%.2f") M$")
                            }
                        }
                        
                        Spacer()
                        
                    }
            
                    CardView(title: "Company") {
                        Text("Number companies: \(viewStore.numberCompany)")
                        
                        SearchField(title: "Rate of success of a company", placeholder: "NASA, ESA, SpaceX...", query: viewStore.binding(get: \.rateOfSuccessSearchQuery, send: MenuAction.companyQueryChanged), completionResult: viewStore.rateOfSuccessSearchCompletion) { query in
                            viewStore.send(.loadRateOfSuccess(query))
                        } completionAction: { completion in
                            viewStore.send(.loadRateOfSuccess(completion))
                        } content: {
                            Text("Rate of success: \(viewStore.rateOfSuccess, specifier: "%.2f") %")
                        }

                    }
                    
                    Spacer()
                }
                .padding(20)
                .navigationTitle("Dashboard")
                .onAppear {
                    viewStore.send(.onAppear)
            }
            }
        }
    }
}
