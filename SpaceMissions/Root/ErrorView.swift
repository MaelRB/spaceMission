//
//  ErrorView.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import SwiftUI

struct ErrorView: View {
    
    let error: Error
    
    var body: some View {
        Text(error.localizedDescription)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .frame(minWidth: 400, minHeight: 60, alignment: .center)
            .padding()
    }
}
