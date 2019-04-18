//
//  Constants.swift
//  Arm
//
//  Created by Dan on 28.09.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation

enum TableCellType: String, CellTypeDescribing {
    // Common
    case programCell
    case programStepCell
}




func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}
