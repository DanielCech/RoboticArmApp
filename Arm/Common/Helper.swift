//
//  Helper.swift
//  Arm
//
//  Created by Dan on 26.04.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

func linear(_ t: Float) -> Float {
    return t
}

func easeInOutCubic(_ t: Float) -> Float {
    return (t < 0.5) ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1
}
