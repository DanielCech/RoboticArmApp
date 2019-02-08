//
//  Program.swift
//  Arm
//
//  Created by Dan on 18.06.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation

import RealmSwift


class Program: Object {
    let steps = List<ProgramStep>()
    @objc dynamic var name = ""
}
