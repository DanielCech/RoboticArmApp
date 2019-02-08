//
//  ProgramStep.swift
//  Arm
//
//  Created by Dan on 18.06.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation
import RealmSwift

enum StepType {
    case move
    case pause
    // interactivity?
}

class ProgramStep: Object {

    @objc dynamic var stepTypeInt = 0

    @objc dynamic var positionX = 0
    @objc dynamic var positionY = 0
    @objc dynamic var positionZ = 0
    @objc dynamic var positionAngle = 0

    @objc dynamic var suctionPump = false

}
