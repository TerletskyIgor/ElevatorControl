//
//  FloorRowView.swift
//  ElevatorControl
//
//  Created by Igor Terletskyi on 03.09.2025.
//

import SwiftUI

struct FloorRowView: View {
    let floorNumber: Int
    let cabinPosition: Double
    let isCabinHere: Bool
    let floorCalls: Bool
    let cabinAction: () -> Void
    let floorCallAction: () -> Void

    var floorNumberNoLeft: some View {
        Text("\(floorNumber)")
            .frame(width: 30)
            .font(.headline)
    }
    
    var shaftCell: some View {
        ZStack {
            Rectangle().fill(Color(white: 0.95)).cornerRadius(6)
            HStack {
                Spacer()
                if isCabinHere {
                    VStack {
                        Text("CABIN")
                            .font(.caption2)
                        Circle().frame(width: 36, height: 36).overlay(Text("\(floorNumber)")).onTapGesture(perform: cabinAction)
                    }
                } else {
                    // show approximate cabin if between floors
                    let delta = abs(Double(floorNumber) - cabinPosition)
                    if delta < 0.6 {
                        Circle().frame(width: 18, height: 18).opacity(0.6)
                    }
                }
                Spacer()
            }
        }
    }
    
    var floorCallPanel: some View {
        VStack {
            Circle().frame(width: 36, height: 36).overlay(Text("Call")).onTapGesture(perform: floorCallAction)
            if floorCalls { Text("●").foregroundColor(.red) }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            floorNumberNoLeft
            shaftCell
            .frame(height: 48)
            floorCallPanel
            .frame(width: 60)
        }
        .padding(.horizontal, 6)
    }
}


//#Preview {
//    FloorRowView()
//}
