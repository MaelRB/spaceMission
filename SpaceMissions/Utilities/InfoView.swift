//
//  InfoView.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 05/01/2022.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                }
                .buttonStyle(.borderless)
                Spacer()
            }
            
            Spacer()

            HStack(spacing: 0) {
                Text("Dataset from ")
                Link(destination: URL(string: "https://www.kaggle.com/agirlcoding/all-space-missions-from-1957")!) {
                    Text("Agirlcoding")
                }
            }
            
            Spacer()
        }
        .padding(15)
        .frame(width: 200, height: 100, alignment: .center)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
