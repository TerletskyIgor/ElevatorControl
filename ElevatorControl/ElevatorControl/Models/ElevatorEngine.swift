//
//  ElevatorEngine.swift
//  ElevatorControl
//
//  Created by Igor Terletskyi on 03.09.2025.
//
import Foundation

enum Direction: String, Codable {
    case up, down, idle
}

struct ElevatorState {
    var currentFloorPosition: Double
    var targetFloors: Set<Int>
    var floorCalls: Set<Int>
    var powerOn: Bool
    var blocked: Bool
    var direction: Direction
}

final class ElevatorEngine {
    private(set) var state: ElevatorState
    private var task: Task<Void, Never>? = nil
    private let floorsCount: Int
    private let speedFloorPerSecond: Double = 0.8
    private let tickInterval: UInt64 = 100_000_000 // 0.1s
    var onStateChanged: ((ElevatorState) -> Void)?
    private let lock = NSLock()

    init(floors: Int = 9) {
        self.floorsCount = floors
        self.state = ElevatorState(currentFloorPosition: 0.0,
                                   targetFloors: [],
                                   floorCalls: [],
                                   powerOn: true,
                                   blocked: false,
                                   direction: .idle)
    }

    func start() {
        stopBackgroundLoop()
        task = Task { [weak self] in
            guard let self = self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: self.tickInterval)
                await self.tick()
            }
        }
    }

    func stopBackgroundLoop() {
        task?.cancel()
        task = nil
    }

    deinit {
        stopBackgroundLoop()
    }

    private func setState(_ mutate: (inout ElevatorState) -> Void) {
        lock.lock()
        
        defer {
            lock.unlock()
        }
        
        mutate(&state)
        DispatchQueue.main.async { [stateCopy = state, cb = self.onStateChanged] in
            cb?(stateCopy)
        }
    }

    func pressCabinButton(floor: Int) {
        guard state.powerOn && !state.blocked else { return }
        setState { s in
            s.targetFloors.insert(floor)
        }
    }

    func pressFloorCall(floor: Int) {
        guard state.powerOn && !state.blocked else { return }
        setState { s in
            s.floorCalls.insert(floor)
        }
    }

    func togglePower(_ on: Bool) {
        setState { s in
            s.powerOn = on
            if !on {
                s.blocked = true
                s.targetFloors.removeAll()
                s.floorCalls.removeAll()
                s.direction = .idle
            } else {
                s.blocked = false
                s.direction = .idle
            }
        }
    }

    private func tick() async {
        if !state.powerOn { return }

        if state.blocked { return }

        let currentPos = state.currentFloorPosition
        let currentFloorFloat = round(currentPos)

        if let next = nearestFloor(from: currentPos, in: Array(state.targetFloors)) {
            moveToward(floor: next)
            return
        }

        if let next = nearestFloor(from: currentPos, in: Array(state.floorCalls)) {
            moveToward(floor: next)
            return
        }

        setState { s in s.direction = .idle }
    }

    private func nearestFloor(from pos: Double, in floors: [Int]) -> Int? {
        guard !floors.isEmpty else { return nil }
        return floors.min(by: { abs(Double($0) - pos) < abs(Double($1) - pos) })
    }

    private func moveToward(floor: Int) {
        let step = speedFloorPerSecond * Double(tickInterval) / 1_000_000_000.0
        setState { s in
            let targetPos = Double(floor)
            if abs(s.currentFloorPosition - targetPos) < 0.02 {
                s.currentFloorPosition = targetPos
                
                s.targetFloors.remove(floor)

                if s.floorCalls.contains(floor) {
                    s.floorCalls.remove(floor)
                }
                s.direction = .idle
            } else if s.currentFloorPosition < targetPos {
                s.currentFloorPosition += step
                s.direction = .up
            } else {
                s.currentFloorPosition -= step
                s.direction = .down
            }
        }
    }
}
