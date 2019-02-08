//
//  ProgramStep.swift
//  Arm
//
//  Created by Dan on 28.09.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation
import RealmSwift

class ProgramStep: Object {
    var positionX: Float?
    var positionY: Float?
    var positionZ: Float?
    var positionAngle: Float?
    var pump: Bool?
}
