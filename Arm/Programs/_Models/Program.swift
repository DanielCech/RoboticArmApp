//
//  Program.swift
//  Arm
//
//  Created by Dan on 28.09.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation
import RealmSwift

class Program: Object {
    var name: String
    
    let steps = List<ProgramStep>()
}
