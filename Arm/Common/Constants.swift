//
//  Constants.swift
//  Arm
//
//  Created by Dan on 28.09.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation

public enum Command: String {
    case none = "0"
    case manual = "1"
    case move = "2"
    case circular = "3"
}


struct Constants {
    static let initialX: Float = 90
    static let initialY: Float = 50
    static let initialZ: Float = 0
    static let initialAngle: Float = 90
}


func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}
