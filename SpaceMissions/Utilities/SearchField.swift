//
//  SearchField.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 05/01/2022.
//

import SwiftUI

struct SearchField<Content: View>: View {
    
    var placeholder: String
    @Binding var query: String
    var completionResult: [String]
    var submitAction: (String) -> Void
    var completionAction: (String) -> Void
    
    let content: Content
    
    init(placeholder: String, query: Binding<String>, completionResult: [String], submitAction: @escaping (String) -> Void, completionAction: @escaping (String) -> Void, @ViewBuilder content: () -> Content) {
        self.placeholder = placeholder
        self._query = query
        self.completionResult = completionResult
        self.submitAction = submitAction
        self.completionAction = completionAction
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(placeholder, text: $query)
                .font(.body.bold())
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .onSubmit {
                    submitAction(query)
                }
            
            if !completionResult.isEmpty {
                ForEach(completionResult, id: \.self) { completion in
                    Button {
                        completionAction(completion)
                    } label: {
                        Text(completion)
                    }
                    .buttonStyle(.borderless)
                }
            } else {
                content
            }
        }
        .padding(.vertical, 10)
    }
}
