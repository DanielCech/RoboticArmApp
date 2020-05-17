//
//  RobotState.swift
//  Arm
//
//  Created by Dan on 20.04.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class RobotState {
    static let shared = RobotState()
    
    var valueX = MutableProperty<Float>(Constants.initialX)
    var valueY = MutableProperty<Float>(Constants.initialY)
    var valueZ = MutableProperty<Float>(Constants.initialZ)
    var valueAngle = MutableProperty<Float>(Constants.initialAngle)
    var valuePump = MutableProperty<Bool>(false)
    var command: Command = .none
    var movementCompletion: SimpleBlock?
    var movementCompletionTimer: Timer?
    
    var isInMotion = false
    
    private var movementTimer: Timer!
    
    init() {
        SignalProducer.combineLatest(valueX.producer, valueY.producer, valueZ.producer, valueAngle.producer, valuePump.producer)
            .throttle(0.2, on: QueueScheduler(qos: .default, name: "search", targeting: DispatchQueue.main))
            .startWithValues { [weak self] _ in
                self?.updateRoboticArm()
            }
        
    }
    
    private func updateRoboticArm() {
        ConnectionManager.shared.control(command: command, x: valueX.value, y: valueY.value, z: valueZ.value, angle: valueAngle.value, pump: valuePump.value)
    }
    
    
}
