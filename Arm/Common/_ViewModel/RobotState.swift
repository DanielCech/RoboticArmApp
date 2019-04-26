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
    var immediately = false
    
    var isInMotion = false
    
    private var movementTimer: Timer!
    
    init() {
        
        SignalProducer.combineLatest(valueX.producer, valueY.producer, valueZ.producer, valueAngle.producer, valuePump.producer)
            .throttle(0.2, on: QueueScheduler(qos: .default, name: "search", targeting: DispatchQueue.main))
            .startWithValues { [weak self] _ in
                self?.updateRoboticArm()
        }
        
    }
    
    func moveTo(x: Float, y: Float, z: Float, time: Float, completion: @escaping SimpleBlock) {
        
        isInMotion = true
        
        let originalX = valueX.value
        let originalY = valueY.value
        let originalZ = valueZ.value
        
        let movementBegin = Date()
        
        DispatchQueue.main.async { [weak self] in
            self?.movementTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                
                let timeDelta = Date().timeIntervalSince(movementBegin)
                
                self?.valueX.value = originalX + (x - originalX) * easeInOutCubic(Float(timeDelta) / time)
                self?.valueY.value = originalY + (y - originalY) * easeInOutCubic(Float(timeDelta) / time)
                self?.valueZ.value = originalZ + (z - originalZ) * easeInOutCubic(Float(timeDelta) / time)
                
                if timeDelta > Double(time) {
                    timer.invalidate()
                    self?.isInMotion = false
                    completion()
                }
            }
        }
    }
    
    func setAngle(alpha: Float, time: Float, completion: @escaping SimpleBlock) {
        isInMotion = true
        
        let originalAngle = valueAngle.value
        let movementBegin = Date()
        
        DispatchQueue.main.async { [weak self] in
            self?.movementTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                
                let timeDelta = Date().timeIntervalSince(movementBegin)
                
                self?.valueAngle.value = originalAngle + (alpha - originalAngle) * easeInOutCubic(Float(timeDelta) / time)
                
                if timeDelta > Double(time) {
                    timer.invalidate()
                    self?.isInMotion = false
                    completion()
                }
            }
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
    
    private func updateRoboticArm() {
        ConnectionManager.shared.control(x: valueX.value, y: valueY.value, z: valueZ.value, angle: valueAngle.value, pump: valuePump.value, immediately: immediately)
    }
    
    
}
