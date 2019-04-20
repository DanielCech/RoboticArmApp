//
//  RobotCommands.swift
//  Arm
//
//  Created by Dan on 15.04.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation
import JavaScriptCore

typealias SimpleBlock = () -> Void

/**
 Protocol declaring all methods and properties that should be exposed to a JS context.
 */
@objc protocol RobotCommandsJSExports: JSExport {
    static func enablePump(_ enable: Bool)
    static func pause(_ seconds: Float)
    static func move(_ axisX: Float, _ axisY: Float, _ axisZ: Float, _ time: Float)
    static func isPlaceFree(_ axisX: Float, _ axisZ: Float) -> Bool
    static func getXAxisOfCube(_ n: Int) -> Int
    static func getZAxisOfCube(_ n: Int) -> Int
}

/**
 Class exposed to a JS context.
 */
@objc @objcMembers class RobotCommands: NSObject, RobotCommandsJSExports {
    
    /// Maps a UUID to a condition lock. One entry is created every time a sound is played and it is
    /// removed playback completion.
    private static var conditionLocks = [String: NSConditionLock]()
    
    static func runSynchronously(code: @escaping (@escaping SimpleBlock) -> Void) {
        // Create a condition lock so we don't return back to JS code until completion is called
        let uuid = NSUUID().uuidString
        self.conditionLocks[uuid] = NSConditionLock(condition: 0)
        
        let completion = {
            // Change the lock condition to "1"
            self.conditionLocks[uuid]?.lock()
            self.conditionLocks[uuid]?.unlock(withCondition: 1)
        }
        
        code(completion)
        
        // Block this thread by waiting for the condition lock to change to "1", which happens when
        // playback is complete.
        // Once this happens, dispose of the lock and let control return back to the JS code (which
        // was the original caller of `MusicMaker.playSound(...)`).
        self.conditionLocks[uuid]?.lock(whenCondition: 1)
        self.conditionLocks[uuid]?.unlock()
        self.conditionLocks[uuid] = nil
    }
    
    static func enablePump(_ enable: Bool) {
        
        print("enablePump \(enable)")
        
        // Create a condition lock for this player so we don't return back to JS code until
        // the player has finished playing.
        let uuid = NSUUID().uuidString
        self.conditionLocks[uuid] = NSConditionLock(condition: 0)
        
        delay(3) {
            self.conditionLocks[uuid] = NSConditionLock(condition: 1)
        }
    }
    
    static func pause(_ seconds: Float) {
        
        print("pause \(seconds)")
        
        runSynchronously { completion in
            delay(Double(seconds)) {
                completion()
            }
        }
    }
    
    static func move(_ axisX: Float, _ axisY: Float, _ axisZ: Float, _ time: Float) {
        
        print("move \(axisX), \(axisY), \(axisZ), \(time)")
        
        runSynchronously { completion in
            delay(Double(time)) {
                completion()
            }
        }
    }
    
    static func isPlaceFree(_ axisX: Float, _ axisZ: Float) -> Bool {
        
        print("isPlaceFree \(axisX), \(axisZ)")
        
        return false
    }
    
    static func getXAxisOfCube(_ n: Int) -> Int {
        
        print("getXAxisOfCube \(n)")
        
        return 1
    }
    
    static func getZAxisOfCube(_ n: Int) -> Int {
        
        print("getZAxisOfCube \(n)")
        
        return 2
    }
}
