//
//  MainView.swift
//  ElevatorControl
//
//  Created by Igor Terletskyi on 03.09.2025.
//

import SwiftUI

struct MainView: View {
    private let floors = Array((0..<9).reversed())
    @State private var viewState = ElevatorState(currentFloorPosition: 0,
                                                 targetFloors: [],
                                                 floorCalls: [],
                                                 powerOn: true,
                                                 blocked: false,
                                                 direction: .idle)
    private let vm = ElevatorViewModel()

    init() { }
    
    var ElevatorShaftWithFloors: some View {
        VStack(spacing: 8) {
            ForEach(floors, id: \.self) { f in
                FloorRowView(floorNumber: f,
                             cabinPosition: viewState.currentFloorPosition,
                             isCabinHere: Int(round(viewState.currentFloorPosition)) == f,
                             floorCalls: viewState.floorCalls.contains(f),
                             cabinAction: { vm.pressCabin(floor: f) },
                             floorCallAction: { vm.pressFloorCall(floor: f) })
                    .frame(height: 60)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke())
    }
    
    var  cabinControl: some View {
        CabinControlPanelView(currentPosition: viewState.currentFloorPosition,
                              pressedTargets: viewState.targetFloors,
                              onPress: { vm.pressCabin(floor: $0) })
            .frame(maxHeight: 300)
    }
    
    var dispatcherControll: some View {
        DispatcherControlPanelView(powerOn: viewState.powerOn,
                                    direction: viewState.direction,
                                    nearestFloor: Int(round(viewState.currentFloorPosition)),
                                    onTogglePower: { vm.togglePower(on: $0) })
    }

    var body: some View {
        HStack(spacing: 12) {
            ElevatorShaftWithFloors

            VStack(spacing: 16) {
                cabinControl
                dispatcherControll
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke())
            .frame(minWidth: 220)
        }
        .padding()
        .onAppear {
            vm.onUpdate = { state in
                self.viewState = state
            }
        }
    }
}

#Preview {
    MainView()
}
