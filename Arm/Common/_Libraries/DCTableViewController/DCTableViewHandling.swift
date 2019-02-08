//
//  DCTableViewHandling.swift
//  Rednote
//
//  Created by Dan Cech on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

// TODO: just for debugging purpuses


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (left?, right?):
    return left < right
  case (nil, _?):
    return true
  default:
    return false
  }
}

var enableDCTableViewControllerLoging = false

enum DCTableViewError: Error {
    case tagIsNotUnique
    case structureNotFound
    case sectionIndexOutOfBounds
    case rowIndexOutOfBounds
}

protocol DCTableViewHandling: class {

//    associatedtype CellDescription: CellDescribing
//    associatedtype SectionDescription: SectionDescribing
    
    /// Dictionary of table structures. Useful when controller contains more than one table view. TableView.tag is used as a key.
    var tableStructures: [Int: DCTableViewStructure<CellDescription, SectionDescription>] { get set }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Table setup
    
    func registerTableView(_ tableView: UITableView) throws
    
    func createDataSourceForTable(_ tableView: UITableView)
    
    func structureForTable(_ table: UITableView) -> DCTableViewStructure<CellDescription, SectionDescription>?
    
    func tableView(
        _ tableView: UITableView,
        addSection section: SectionDescription,
        withCells cells: [CellDescription])
    
    func clearPreviousTableState(_ tableView: UITableView)
    
    func resetTableChanges(_ tableView: UITableView)

    ////////////////////////////////////////////////////////////////
    // MARK: - TableView data source methods
    
    func protocolNumberOfSectionsInTableView(_ tableView: UITableView, currentState: Bool) -> Int
    func protocolTableView(_ tableView: UITableView, numberOfRowsInSection section: Int, currentState: Bool) -> Int
    
    ////////////////////////////////////////////////////////////////
    // Cell
    
    func protocolTableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath, currentState: Bool, cellDescription: CellDescription?) -> CGFloat
    func protocolTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, currentState: Bool, cellDescription: CellDescription?) -> CGFloat
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func protocolTableView(_ tableView: UITableView, titleForHeaderInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> String?

    func protocolTableView(_ tableView: UITableView, heightForHeaderInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> CGFloat
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func protocolTableView(_ tableView: UITableView, titleForFooterInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> String?
    
    func protocolTableView(_ tableView: UITableView, heightForFooterInSection section: Int, currentState: Bool, sectionDescription: SectionDescription?) -> CGFloat
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func protocolTableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription?)
    
    func protocolTableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription?)
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using sectionID and cellID

    func tableView(
        _ tableView: UITableView,
        descriptionForCellWithID cellID: IntConvertibleProtocol,
        inSectionWithID sectionID: IntConvertibleProtocol,
        currentState: Bool) -> CellDescription?
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSectionWithID section: IntConvertibleProtocol,
        currentState: Bool) -> SectionDescription?
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSectionWithID sectionID: IntConvertibleProtocol,
        currentState: Bool) -> String?
    
    func tableView(
        _ tableView: UITableView,
        sectionIDForSectionIndex section: Int,
        currentState: Bool) -> IntConvertibleProtocol?
    
    func tableView(
        _ tableView: UITableView,
        indexOfSectionWithID sectionID: IntConvertibleProtocol,
        currentState: Bool) -> Int?
    
    func tableView(_ tableView: UITableView, reloadSectionWithID sectionID: IntConvertibleProtocol, rowAnimation: UITableViewRowAnimation)
    
    func tableView(_ tableView: UITableView, cellDescriptionsForSectionWithID sectionID: IntConvertibleProtocol, currentState: Bool) -> [CellDescription]
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using indexPath
    
    func tableView(
        _ tableView: UITableView,
        descriptionForCellAtIndexPath indexPath: IndexPath,
        currentState: Bool) -> CellDescription?
    
    func tableView(
        _ tableView: UITableView,
        viewModelForCellAtIndexPath indexPath: IndexPath,
        currentState: Bool) -> Any?
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSection section: Int,
        currentState: Bool) -> SectionDescription?
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Animated table changes
    
    func animateTableChanges(
        _ tableView: UITableView,
        withUpdates: Bool,
        inSections: [IntConvertibleProtocol]?,
        insertAnimation: UITableViewRowAnimation,
        deleteAnimation: UITableViewRowAnimation)

}

extension DCTableViewHandling {
    
    ////////////////////////////////////////////////////////////////
    // Table setup
    
    func registerTableView(_ tableView: UITableView) throws {
        if tableStructures[tableView.tag] != nil {
            throw DCTableViewError.tagIsNotUnique
        }
        
        let structure = DCTableViewStructure<CellDescription, SectionDescription>() //DCTableViewStructure<CellDescription, SectionDescription>()
        
        tableStructures[tableView.tag] = structure
    }
    
    func createDataSourceForTable(_ tableView: UITableView) {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }

//        _debugDataSource(tableView: tableView, caption: "previous")

        structure!.previousDataSourceCells = structure!.dataSourceCells
        structure!.previousDataSourceSections = structure!.dataSourceSections
        
        structure!.dataSourceCells = []
        structure!.dataSourceSections = []
        
        tableStructures[tableView.tag] = structure!
    }
    
    func structureForTable(_ table: UITableView) -> DCTableViewStructure<CellDescription, SectionDescription>? {
//        assertMainThread()
        let structure = tableStructures[table.tag]
        
        if structure == nil {
            return nil
        }
        
        return structure!
    }
    
    func tableView(
        _ tableView: UITableView,
        addSection section: SectionDescription,
        withCells cells: [CellDescription]) {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }
        
        structure!.dataSourceSections.append(section)
        structure!.dataSourceCells.append(cells)
        
        tableStructures[tableView.tag] = structure!
    }
    
    func clearPreviousTableState(_ tableView: UITableView) {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }
        
        structure!.previousDataSourceCells = []
        structure!.previousDataSourceSections = []
    }
    
    func resetTableChanges(_ tableView: UITableView) {
        var structure = structureForTable(tableView)
        if structure == nil {
            return
        }
        
        structure!.previousDataSourceCells = structure!.dataSourceCells
        structure!.previousDataSourceSections = structure!.dataSourceSections
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - TableView data source methods
    
    func protocolNumberOfSectionsInTableView(_ tableView: UITableView, currentState: Bool = true) -> Int {
        let structure = structureForTable(tableView)
        if structure == nil {
            return 0
        }

        return structure!.getDataSourceSections(currentState).count
    }
    
    func protocolTableView(_ tableView: UITableView, numberOfRowsInSection section: Int, currentState: Bool = true) -> Int {
        let structure = structureForTable(tableView)
        if structure == nil {
            return 0
        }
        
        let dataSourceCells = structure!.getDataSourceCells(currentState)
        
        if section < dataSourceCells.count {
            return dataSourceCells[section].count
        }

        return 0
    }
    
    ////////////////////////////////////////////////////////////////
    // Cell

    func protocolTableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath,
        currentState: Bool = true,
        cellDescription: CellDescription? = nil) -> CGFloat {
        if let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) {
            if let unwrappedEstimatedCellHeight = cellDescription.estimatedCellHeight {
                return unwrappedEstimatedCellHeight(cellDescription, indexPath)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    func protocolTableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath,
        currentState: Bool = true,
        cellDescription: CellDescription? = nil) -> CGFloat {
        if let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) {
            if let unwrappedCellHeight = cellDescription.cellHeight {
                return unwrappedCellHeight(cellDescription, indexPath)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    func protocolTableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int,
        currentState: Bool = true, sectionDescription: SectionDescription? = nil) -> String? {
        let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState)
        return sectionDescription?.headerTitle
    }
    
    func protocolTableView(_ tableView: UITableView, heightForHeaderInSection section: Int, currentState: Bool = true, sectionDescription: SectionDescription? = nil) -> CGFloat {
        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
            if let unwrappedHeaderHeight = sectionDescription.headerHeight {
                return unwrappedHeaderHeight(sectionDescription, section)
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    func protocolTableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int,
        currentState: Bool = true,
        sectionDescription: SectionDescription? = nil) -> String? {
        guard let sectionDescription = self.tableView(tableView, descriptionForSection: section, currentState: currentState) else { return nil }
        return sectionDescription.footerTitle
    }
    
    func protocolTableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int,
        currentState: Bool = true,
        sectionDescription: SectionDescription? = nil) -> CGFloat {
        if let sectionDescription = sectionDescription ?? self.tableView(tableView, descriptionForSection: section, currentState: currentState) {
            if let unwrappedFooterHeight = sectionDescription.footerHeight {
                return unwrappedFooterHeight(sectionDescription, section)
            }
        }
        
        return 0
    }
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    func protocolTableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription? = nil) {
        guard let unwrappedCellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) else { return }
        
        if let didSelectCell = unwrappedCellDescription.didSelectCell {
            if let unwrappedCell = tableView.cellForRow(at: indexPath) {
                didSelectCell(unwrappedCell, unwrappedCellDescription, indexPath)
            }
        }
    }
    
    func protocolTableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath, cellDescription: CellDescription? = nil) {
        guard let unwrappedCellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true) else { return }
        
        if let didDeselectCell = unwrappedCellDescription.didDeselectCell {
            if let unwrappedCell = tableView.cellForRow(at: indexPath) {
                didDeselectCell(unwrappedCell, unwrappedCellDescription, indexPath)
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using sectionID and cellID
    
    func tableView(
        _ tableView: UITableView,
        descriptionForCellWithID cellID: IntConvertibleProtocol,
        inSectionWithID sectionID: IntConvertibleProtocol,
        currentState: Bool = true) -> CellDescription? {
        // TODO: implementation is missing - use binary search
        return nil
        
//        let cellDescription = self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: currentState)
    }
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSectionWithID sectionID: IntConvertibleProtocol,
        currentState: Bool) -> SectionDescription? {
        // TODO: implementation is missing
        return nil
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSectionWithID sectionID: IntConvertibleProtocol,
        currentState: Bool = true) -> String? {
        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true) {
            return self.protocolTableView(tableView, titleForHeaderInSection: sectionIndex)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, sectionIDForSectionIndex section: Int, currentState: Bool = true) -> IntConvertibleProtocol? {
        guard let sectionDescription = self.tableView(tableView, descriptionForSection: section, currentState: currentState) else { return nil }
    
        return sectionDescription.sectionID.intValue()
    }
    
    func tableView(_ tableView: UITableView, indexOfSectionWithID sectionID: IntConvertibleProtocol, currentState: Bool = true) -> Int? {
        if let structure = structureForTable(tableView) {
            if let sectionIndex = structure.indexOfSectionWithID(sectionID, currentState: currentState) {
                return sectionIndex.intValue()
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, reloadSectionWithID sectionID: IntConvertibleProtocol, rowAnimation: UITableViewRowAnimation = .automatic) {

        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true) {
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: rowAnimation)
        }
    }
    
    func tableView(_ tableView: UITableView, cellDescriptionsForSectionWithID sectionID: IntConvertibleProtocol, currentState: Bool = true) -> [CellDescription] {
        let structure = structureForTable(tableView)
        if let sectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: currentState) {
            if let cellDescriptions = structure?.getDataSourceCells(currentState) {
                if sectionIndex < cellDescriptions.count {
                    return cellDescriptions[sectionIndex]
                }
            }
        }
        
        return []
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Access using indexPath
    
    func tableView(
        _ tableView: UITableView,
        descriptionForCellAtIndexPath indexPath: IndexPath,
        currentState: Bool = true) -> CellDescription? {
        let structure = structureForTable(tableView)
        
        if let unwrappedStructure = structure {
            
            if indexPath.section >= unwrappedStructure.dataSourceCells.count {
                return nil
            }
            
            if indexPath.row >= unwrappedStructure.dataSourceCells[indexPath.section].count {
                return nil
            }
            
            return unwrappedStructure.dataSourceCells[indexPath.section][indexPath.row]
        }
        else {
            return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        viewModelForCellAtIndexPath indexPath: IndexPath,
        currentState: Bool) -> Any? {
        
        if let cellDescription = self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: currentState) {
            return cellDescription.viewModel
        }
        else {
            return nil
        }
    }
    
    
    func tableView(
        _ tableView: UITableView,
        descriptionForSection section: Int,
        currentState: Bool = true) -> SectionDescription? {
        
        
        let structure = structureForTable(tableView)
        guard let unwrappedStructure = structure else {
            return nil
        }
        
        if unwrappedStructure.dataSourceSections.isEmpty {
            return nil
        }
        
        if section < unwrappedStructure.dataSourceSections.count {
            return unwrappedStructure.dataSourceSections[section]
        }
        
        return nil
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: - Animated table changes
    
    // swiftlint:disable function_body_length
    
    func animateTableChanges(
        _ tableView: UITableView,
        withUpdates: Bool,
        inSections: [IntConvertibleProtocol]? = nil,
        insertAnimation: UITableViewRowAnimation = .automatic,
        deleteAnimation: UITableViewRowAnimation = .automatic) {
        guard let structure = structureForTable(tableView) else {
            return
        }

//        assertMainThread()

//        _debugDataSource(tableView: tableView, caption: "current")

//        if enableDCTableViewControllerLoging { Lighthouse.reportDebug("AnimateTableChangesStart") }

        let visibleCells = tableView.visibleCells
        let visibleCellsIndexPaths = visibleCells.map { cell in
            tableView.indexPath(for: cell)!
        }
        
        var sectionsToInsert: [IntConvertibleProtocol] = []
        var sectionsToDelete: [IntConvertibleProtocol] = []
        
        var rowsToInsert: [IndexPath] = []
        var rowsToDelete: [IndexPath] = []
        
        let previousSectionIDs = structure.previousDataSourceSections.map { (section) -> Int in
            section.sectionID.intValue()
        }
        
        let currentSectionIDs = structure.dataSourceSections.map { (section) -> Int in
            section.sectionID.intValue()
        }
        
        // Result when we delete items from previous array that are not in current array
        let previousSectionIDsFiltration = DCHelper.deleteUnusedPreviousValues(previousArray: previousSectionIDs, currentArray: currentSectionIDs)
        sectionsToDelete = previousSectionIDsFiltration.deletion
        
        // Sequence of insertions that transforms previousArrayFiltration to currentSectionIDs
        let insetions = DCHelper.insertionsInArray(previousArray: previousSectionIDsFiltration.result, currentArray: currentSectionIDs)
        
        sectionsToInsert = insetions.map({ (position: IntConvertibleProtocol, _: IntConvertibleProtocol) in
            return position
        })
        
        // Add rows from inserted sections
        for insetion in insetions {
            let currentSectionIndex = self.tableView(tableView, indexOfSectionWithID: insetion.value, currentState: true)
            let cellDescriptions = structure.dataSourceCells[currentSectionIndex!]
            
            for index in cellDescriptions.indices {
                rowsToInsert.append(IndexPath(row: index, section: insetion.position.intValue()))
            }
        }
        
        if enableDCTableViewControllerLoging {
//            Lighthouse.reportDebug("    previousSectionIDsFiltration.result \(previousSectionIDsFiltration.result)")
        }
        
        // Process rows for section common for previous and current arrays
        for sectionID in previousSectionIDsFiltration.result {
//            if enableDCTableViewControllerLoging {  Lighthouse.reportDebug("    Processing section '\(sectionID)") }

            let previousSectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: false)!
            
            let currentSectionIndex = self.tableView(tableView, indexOfSectionWithID: sectionID, currentState: true)!
            
            if enableDCTableViewControllerLoging {
//                Lighthouse.reportDebug("        previousSectionIndex \(previousSectionIndex), currentSectionIndex \(currentSectionIndex)")
            }
            
            let previousSectionCellIDs = structure.previousDataSourceCells[previousSectionIndex].map({ cellDescription in
                cellDescription.cellID!
            })
            
            if enableDCTableViewControllerLoging {
//                Lighthouse.reportDebug("        previousSectionCellIDs \(previousSectionCellIDs)")
            }
            
            let currentSectionCellIDs = structure.dataSourceCells[currentSectionIndex].map({ cellDescription in
                cellDescription.cellID!
            })
            
            if enableDCTableViewControllerLoging {
//                Lighthouse.reportDebug("        currentSectionCellIDs \(currentSectionCellIDs)")
            }
            
            // Row deletion
            // Result when we delete items from previous array that are not in current array
            let previousSectionCellIDsFiltration = DCHelper.deleteUnusedPreviousValues(previousArray: previousSectionCellIDs.map({ $0.intValue()}), currentArray: currentSectionCellIDs.map({ $0.intValue()}))
            
            if enableDCTableViewControllerLoging {
//                Lighthouse.reportDebug("        previousSectionCellIDsFiltration.result \(previousSectionCellIDsFiltration.result)")
//                Lighthouse.reportDebug("        previousSectionCellIDsFiltration.deletion \(previousSectionCellIDsFiltration.deletion)")
            }
            
            let sectionCellsToDelete = previousSectionCellIDsFiltration.deletion.map({ rowIndex in
                IndexPath(row: rowIndex.intValue(), section: previousSectionIndex)
            })
            
            rowsToDelete += sectionCellsToDelete
            
            // Check row updates
            if withUpdates {
                
                // Find all cells in previous section
                for (previousIndex, previousCellID) in previousSectionCellIDs.enumerated() {
                    // Filter cells for updating
                    if previousSectionCellIDsFiltration.result.map({ $0.intValue() }).index(of: previousCellID.intValue()) != nil {
                        
                        let previousIndexPath = IndexPath(row: previousIndex, section: previousSectionIndex)
                        
                        // Is the cell visible?
                        if let visibleCellIndex = visibleCellsIndexPaths.index(of: previousIndexPath) {
                            if let cell = visibleCells[visibleCellIndex] as? DCTableViewCellProtocol {
                                
                                // Find indexPath of cell in a new data source
                                for (currentIndex, currentCellID) in currentSectionCellIDs.enumerated() {
                                    if currentCellID.intValue() == previousCellID.intValue() {
                                        let currentIndexPath = IndexPath(row: currentIndex, section: currentSectionIndex)
                                        if let cellDescription = self.tableView(tableView, descriptionForCellAtIndexPath: currentIndexPath) {
                                            // Update visible cell with the new viewModel
                                            if let viewModel = cellDescription.viewModel {
                                                cell.updateCell(viewModel: viewModel, delegate: cellDescription.delegate)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Row insertions
            // Sequence of insertions that transforms previousArrayFiltration to currentSectionIDs
            let sectionCellsToInsert = DCHelper.insertionsInArray(
                previousArray: previousSectionCellIDsFiltration.result,
                currentArray: currentSectionCellIDs).map({ insertion in
                IndexPath(row: insertion.position.intValue(), section: currentSectionIndex)
            })
            if enableDCTableViewControllerLoging {
//                Lighthouse.reportDebug("        sectionCellsToInsert \(DCHelper.displayIndexPaths(sectionCellsToInsert))")
            }
            
            rowsToInsert += sectionCellsToInsert
        }
        
        if enableDCTableViewControllerLoging {
//            Lighthouse.reportDebug("    sectionsToDelete: \(sectionsToDelete)")
//            Lighthouse.reportDebug("    rowsToDelete: \(DCHelper.displayIndexPaths(rowsToDelete))")
//            Lighthouse.reportDebug("    sectionsToInsert: \(sectionsToInsert)")
//            Lighthouse.reportDebug("    rowsToInsert: \(DCHelper.displayIndexPaths(rowsToInsert))")
//        
//            Lighthouse.reportDebug("AnimateTableChangesEnd")
        }


//        do {
//            try DCExceptionHandler.catchException {
                tableView.beginUpdates()

                // 1. remove sections
                for sectionIndex in sectionsToDelete {
                    tableView.deleteSections(IndexSet(integer: sectionIndex.intValue()), with: deleteAnimation)
                }

                // 2. remove cells
                tableView.deleteRows(at: rowsToDelete, with: deleteAnimation)

                // 3. insert sections
                for sectionIndex in sectionsToInsert {
                    tableView.insertSections(IndexSet(integer: sectionIndex.intValue()), with: insertAnimation)
                }

                // 4. insert cells
                tableView.insertRows(at: rowsToInsert, with: insertAnimation)

                tableView.endUpdates()
//            }
//        }
//        catch let error {
//            log.error("animateTableChanges [Error]: \(error)")
//            tableView.reloadData()
//        }

    }


//    private func _debugDataSource(tableView: UITableView, caption: String) {
//        guard let structure = structureForTable(tableView) else {
//            return
//        }
//        print("DataSource: \(caption) begin ===========================")
//
//        print("DataSourceSections:")
//        for section in structure.dataSourceSections {
//            print("    \(section.headerTitle ?? "<no title>"):\(section.sectionID)")
//        }
//
//        print("DataSourceCells:")
//        for (index, cellSection) in structure.dataSourceCells.enumerated() {
//            print("    Cell section: \(index)")
//            for (cellIndex, cell) in cellSection.enumerated() {
//                if let connectionViewModel = cell.viewModel as? ConnectionViewModel {
//                    print("        Cell \(cellIndex), Name: \(connectionViewModel.fullName()), ID: \(cell.cellID ?? -1)")
//                }
//                else {
//                    print("        Cell \(cellIndex): <problem>, ID: \(cell.cellID ?? -1)")
//                }
//            }
//        }
//        print("DataSource: \(caption) end ==============================")
//    }

}
