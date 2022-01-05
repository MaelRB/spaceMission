//
//  ToolbarInfoModifier.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 05/01/2022.
//

import SwiftUI

struct ToolbarInfo: ViewModifier {
    
    @Binding var showInfoView: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                Button {
                    showInfoView.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
    }
}

extension View {
    func toolbarInfo(show: Binding<Bool>) -> some View {
        modifier(ToolbarInfo(showInfoView: show))
    }
}
