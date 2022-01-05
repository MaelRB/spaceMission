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
            VStack {
                HStack(alignment: .top, spacing: 20) {
                    CardView(title: "Number") {
                        Text("Number companies: \(viewStore.numberCompany)")
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
                    }
                    
                    CardView(title: "Cost") {
                        Text("Highest average cost: \(viewStore.highestAvgCost.name) | \(viewStore.highestAvgCost.cost, specifier: "%.2f") M$")
                        Text("Total cost: \(viewStore.totalCost, specifier: "%.2f") M$")
                        VStack(alignment: .leading, spacing: 8) {
                            TextField(
                                "NASA, ESA, SpaceX...",
                                text: viewStore.binding(
                                    get: \.companyCostQuery, send: MenuAction.companyCostQueryChanged
                                )
                            )
                            .font(.body.bold())
                            .textFieldStyle(.plain)
                            .disableAutocorrection(true)
                            .onSubmit {
                                print(viewStore.companyCostQuery)
                                viewStore.send(.loadCompanyCost(viewStore.companyCostQuery))
                            }
                            
                            if !viewStore.companyCompletion.isEmpty {
                                ForEach(viewStore.companyCompletion, id: \.self) { completion in
                                    Button {
                                        viewStore.send(.loadCompanyCost(completion))
                                    } label: {
                                        Text(completion)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            } else {
                                Text("Total cost \(viewStore.companyCost, specifier: "%.2f") M$")
                            }
                            
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Spacer()
                }
                .padding(20)
                
                Spacer()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewStore.send(.onAppearGetHighestAvgCost)
                viewStore.send(.onAppearGetTotalCost)
                viewStore.send(.onAppearGetNumberMissionActive)
                viewStore.send(.onAppearGetNumberCompany)
                viewStore.send(.onAppearGetNumberMission)
                viewStore.send(.onAppearLoadCompany)
            }
        }
    }
}
