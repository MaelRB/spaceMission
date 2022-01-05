//
//  CardView.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 03/01/2022.
//

import SwiftUI

struct CardView<Content: View>: View {
    
    var title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding(.top, 5)
        }
        .frame(minWidth: 175, idealWidth: 225, maxWidth: 250)
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).foregroundColor(Color("cardBackground")).shadow(radius: 0.25))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Title") {}
    }
}
