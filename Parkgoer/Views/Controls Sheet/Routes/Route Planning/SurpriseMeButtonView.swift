//
//  SurpriseMeButtonView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct SurpriseMeButtonView: View {
    
    var action: (() -> Void)
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    private let gradientsPill: [LinearGradient] = [
        LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.red, .teal], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.teal, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.orange, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
    ]
    
    var body: some View {
        ZStack {
            PhaseAnimator(Array(0...5)) { value in
                Capsule()
                    .stroke(
                        gradientsPill[value],
                        lineWidth: 10
                    )
                    .blur(radius: 10)
                    .brightness(0.6)
                    .clipShape(Capsule())
            } animation: { _ in
                Animation.linear(duration: 1)
            }
            Button {
                action()
            } label: {
                Label("Surprise Me!", systemImage: "sparkles")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color(uiColor: .label))
            }
            .buttonStyle(.bordered)
        }
    }
}
