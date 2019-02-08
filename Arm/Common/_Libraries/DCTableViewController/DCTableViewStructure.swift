//
//  DCTableViewStructure.swift
//  Rednote
//
//  Created by Dan Cech on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

struct DCTableViewStructure<C: CellDescribing, S: SectionDescribing> {

    var dataSourceCells: [[C]] = []
    var previousDataSourceCells: [[C]] = []
    
    var dataSourceSections: [S] = []
    var previousDataSourceSections: [S] = []
    
    ////////////////////////////////////////////////////////////////
    // Public interface
    
    init() {
        
    }
    
    /**
     Retrieve the table cells description structure
     - parameter current: current of previous state of table
     - returns: array for each section containing cell descriptions
     */
    func getDataSourceCells(_ currentState: Bool) -> [[C]] {
        if currentState {
            return dataSourceCells
        }
        else {
            return previousDataSourceCells
        }
    }
    
    /**
     Retrieve the table section description structure
     - parameter current: current of previous state of table
     - returns: array of section descriptions
     */
    func getDataSourceSections(_ currentState: Bool) -> [S] {
        if currentState {
            return dataSourceSections
        }
        else {
            return previousDataSourceSections
        }
    }
    
    /**
     Get the index of section with given sectionID
     - parameter sectionID: ID of section
     - parameter current:   current of previous state of table
     - returns: index of section or nil
     */
    func indexOfSectionWithID(_ sectionID: IntConvertibleProtocol, currentState: Bool = true) -> IntConvertibleProtocol? {
        var index = 0
        
        for currentSection in getDataSourceSections(currentState) {
            if sectionID.intValue() == currentSection.sectionID.intValue() {
                return index
            }
            
            index += 1
        }
        
        return nil
    }
}
