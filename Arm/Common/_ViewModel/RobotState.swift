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
        
        if time < 0.2 {
            UIAlertController.show(title: "Error", message: "Time is too small.")
            completion()
            return
        }
        
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
        
        if time < 0.2 {
            UIAlertController.show(title: "Error", message: "Time is too small.")
            completion()
            return
        }
        
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
        
        if time < 0.2 {
            UIAlertController.show(title: "Error", message: "Time is too small.")
            completion()
            return
        }
        
        isInMotion = true
        
        let originalX = self.valueX.value
        let originalZ = self.valueZ.value
        
        // Initial movement
        moveTo(x: valueX.value + radius, y: valueY.value, z: valueZ.value, time: 2) { [weak self] in
        
            guard let self = self else { return }
            
            let movementBegin = Date()
            
            DispatchQueue.main.async { [weak self] in
                self?.movementTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                    
                    let timeDelta = Date().timeIntervalSince(movementBegin)
                    
                    self?.valueX.value = originalX + radius * cos((Float(timeDelta) / time) * 2 * Float.pi)
                    self?.valueZ.value = originalZ + radius * sin((Float(timeDelta) / time) * 2 * Float.pi)
                    
                    if timeDelta > Double(time) {
                        timer.invalidate()
                        self?.isInMotion = false
                        completion()
                    }
                }
            }
        }
    }
    
    func enablePump(enable: Bool) {
        valuePump.value = enable
    }
    
    private func updateRoboticArm() {
        ConnectionManager.shared.control(command: command, x: valueX.value, y: valueY.value, z: valueZ.value, angle: valueAngle.value, pump: valuePump.value)
    }
    
    
}
