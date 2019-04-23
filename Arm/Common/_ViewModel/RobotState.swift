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
    
    var valueX = MutableProperty<Float>(0)
    var valueY = MutableProperty<Float>(0)
    var valueZ = MutableProperty<Float>(0)
    var valueAngle = MutableProperty<Float>(0)
    var valuePump = MutableProperty<Bool>(false)
    
    init() {
        
    }
    
    func moveTo(x: Float, y: Float, z: Float, time: Float, completion: @escaping SimpleBlock) {
        delay(Double(time)) {
            completion()
        }
    }
    
    func setAngle(alpha: Float, time: Float, completion: @escaping SimpleBlock) {
        delay(Double(time)) {
            completion()
        }
    }

    func circularMovement(radius: Float, time: Float, completion: @escaping SimpleBlock) {
        delay(Double(time)) {
            completion()
        }
    }
    
    func enablePump(enable: Bool) {
        valuePump.value = enable
    }
}
