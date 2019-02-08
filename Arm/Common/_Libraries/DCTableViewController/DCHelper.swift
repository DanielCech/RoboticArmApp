//
//  DCHelper.swift
//  DCTableViewController
//
//  Created by Dan Cech on 06.10.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

class DCHelper: NSObject {

    // Values in arrays are ascending
    class func deleteUnusedPreviousValues(previousArray: [IntConvertibleProtocol], currentArray: [IntConvertibleProtocol], updateIndex: Bool = true) -> (result: [IntConvertibleProtocol], deletion: [IntConvertibleProtocol]) {
        var previousArrayFiltered: [IntConvertibleProtocol] = []
        var deletion: [IntConvertibleProtocol] = []
        
        var previousIndex = 0
        var currentIndex = 0
        var createdIndex = 0
        
        while true {
            if previousIndex >= previousArray.count {
                break
            }
            
            if currentIndex >= currentArray.count {
                deletion.append(createdIndex)
                previousIndex += 1
                if updateIndex {
                    createdIndex += 1
                }
                continue
            }
            
            let previousValue = previousArray[previousIndex]
            let currentValue = currentArray[currentIndex]
            
            if previousValue.intValue() < currentValue.intValue() {
                deletion.append(createdIndex)
                previousIndex += 1
                if updateIndex {
                    createdIndex += 1
                }
            }
            else if currentValue.intValue() < previousValue.intValue() {
                currentIndex += 1
            }
            else {  // Equal
                previousIndex += 1
                currentIndex += 1
                createdIndex += 1
                previousArrayFiltered.append(currentValue)
            }
        }
        
        return (result: previousArrayFiltered, deletion: deletion)
    }
    
    class func insertionsInArray(previousArray: [IntConvertibleProtocol], currentArray: [IntConvertibleProtocol]) -> [(position: IntConvertibleProtocol, value: IntConvertibleProtocol)] {
        var toInsert: [(position: IntConvertibleProtocol, value: IntConvertibleProtocol)] = []
        
        var previousIndex = 0
        var currentIndex = 0
        var createdIndex = 0
        
        while true {
            let previousEnd = (previousIndex >= previousArray.count)
            let currentEnd = (currentIndex >= currentArray.count)
            
            if previousEnd && currentEnd {
                break
            }
            else if previousEnd && !currentEnd {
                toInsert.append((position: createdIndex, value: currentArray[currentIndex].intValue()))
                currentIndex += 1
                createdIndex += 1
            }
            else if !previousEnd && currentEnd {
                break
            }
            else if !previousEnd && !currentEnd {
                
                let previousValue = previousArray[previousIndex]
                let currentValue = currentArray[currentIndex]
                
                if previousValue.intValue() < currentValue.intValue() {
                    toInsert.append((position: createdIndex, value: currentArray[currentIndex]))
                    previousIndex += 1
                    createdIndex += 1
                }
                else if currentValue.intValue() < previousValue.intValue() {
                    toInsert.append((position: createdIndex, value: currentArray[currentIndex]))
                    currentIndex += 1
                    createdIndex += 1
                }
                else {  // Equal
                    previousIndex += 1
                    currentIndex += 1
                    createdIndex += 1
                }
                
            }
            
        }
        
        return toInsert
    }
    
    class func transformArray(_ previousArray: [IntConvertibleProtocol], currentArray: [IntConvertibleProtocol]) -> (toDelete: [IntConvertibleProtocol], toInsert: [(position: IntConvertibleProtocol, value: IntConvertibleProtocol)]) {
        let filtration = deleteUnusedPreviousValues(previousArray: previousArray, currentArray: currentArray)
        
        let insetions = insertionsInArray(previousArray: filtration.result, currentArray: currentArray)
        
        return (toDelete: filtration.deletion, toInsert: insetions)
    }
    
    class func testTransform(_ originalArray: [Int], toDelete: [Int], toInsert: [(position: Int, value: Int)]) -> [Int] {
        var array = originalArray
        
        for index in toDelete {
            if index > array.count {
                if enableDCTableViewControllerLoging {
//                    Lighthouse.reportDebug("deletion problem: \(index), array \(array)")
                }
            }
            else {
                array.remove(at: index)
            }
        }
        
        for insertion in toInsert {
            if insertion.position > array.count {
                if enableDCTableViewControllerLoging {
//                    Lighthouse.reportDebug("insetion problem: \(insertion)")
                }
            }
            else {
                array.insert(insertion.value, at: insertion.position)
            }
        }
        
        return array
    }
    
    class func displayIndexPaths(_ indexPaths: [IndexPath]) -> [String] {
        return indexPaths.map { (indexPath) in
            "<\(indexPath.section), \(indexPath.row)>"
        }
    }
    
}
