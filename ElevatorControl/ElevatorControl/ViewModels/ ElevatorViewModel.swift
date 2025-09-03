//
//   ElevatorViewModel.swift
//  ElevatorControl
//
//  Created by Igor Terletskyi on 03.09.2025.
//

import Foundation

final class ElevatorViewModel {
    private let engine: ElevatorEngine
    var onUpdate: ((ElevatorState) -> Void)?

    init(engine: ElevatorEngine = ElevatorEngine()) {
        self.engine = engine
        engine.onStateChanged = { [weak self] state in
            self?.onUpdate?(state)
        }
        engine.start()
    }

    func pressCabin(floor: Int) {
        engine.pressCabinButton(floor: floor)
    }

    func pressFloorCall(floor: Int) {
        engine.pressFloorCall(floor: floor)
    }
    
    func togglePower(on: Bool) {
        engine.togglePower(on)
    }
}
