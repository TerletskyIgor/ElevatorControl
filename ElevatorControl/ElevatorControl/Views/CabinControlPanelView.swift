//
//  CabinControlPanelView.swift
//  ElevatorControl
//
//  Created by Igor Terletskyi on 03.09.2025.
//

import SwiftUI

struct CabinControlPanelView: View {
    let currentPosition: Double
    let pressedTargets: Set<Int>
    let onPress: (Int) -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text("Cabin Control")
                .font(.headline)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach((0..<9).reversed(), id: \.self) { f in
                    Button(action: { onPress(f) }) {
                        ZStack {
                            Circle().frame(width: 44, height: 44)
                            Text("\(f)")
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .overlay(
                        Circle().stroke(pressedTargets.contains(f) ? Color.yellow : Color.clear, lineWidth: 3)
                    )
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    CabinControlPanelView()
//}
