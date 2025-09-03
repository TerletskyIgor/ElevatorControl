//
//  DispatcherControlPanelView.swift
//  ElevatorControl
//
//  Created by Igor Terletskyi on 03.09.2025.
//

import SwiftUI

struct DispatcherControlPanelView: View {
    let powerOn: Bool
    let direction: Direction
    let nearestFloor: Int
    let onTogglePower: (Bool) -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Dispatcher")
                .font(.headline)
            Toggle(isOn: Binding(get: { powerOn }, set: { onTogglePower($0) })) {
                Text(powerOn ? "Power: On" : "Power: Off")
            }
            .labelsHidden()
            HStack(spacing: 12) {
                Text("Dir:")
                Text(direction == .up ? "↑" : direction == .down ? "↓" : "—")
                    .font(.title)
                Text("Nearest: \(nearestFloor)")
            }
        }
        .padding()
    }
}

//#Preview {
//    DispatcherControlPanelView()
//}
