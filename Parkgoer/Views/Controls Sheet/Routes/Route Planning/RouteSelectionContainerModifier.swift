//
//  RouteSelectionContainerModifier.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RouteSelectionContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular,
                             in: RoundedRectangle(cornerRadius: 24))
        } else {
            content
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(RouteSelectionContainerModifier())
}
