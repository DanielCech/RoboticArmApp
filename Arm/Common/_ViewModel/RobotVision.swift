//
//  RobotVision.swift
//  Arm
//
//  Created by Dan on 20.04.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

struct Point {
    var x: CGFloat
    var z: CGFloat
}


class RobotVision {
    static let shared = RobotVision()
    
    
    /// Dictionary containing info for
    var cubesPosition = [Int: Point]()
    
    
    init() {
        
    }
    
    func resetInfoForCube(number: Int) {
        cubesPosition[number] = nil
    }
    
    func getXAxisForCube(number: Int) -> CGFloat? {
        return cubesPosition[number]?.x
    }
    
    func getZAxisForCube(number: Int) -> CGFloat? {
        return cubesPosition[number]?.z
    }
    
    func seekForCube(number: Int, completion: @escaping SimpleBlock) {
        seekPlayground { [weak self] stopSeeking in
            if self?.cubesPosition[number] != nil {
                stopSeeking()
                completion()
            }
        }
    }
    
    func seekPlayground(cubesPositionUpdate: @escaping (@escaping SimpleBlock) -> Void) {
        
    }
}

