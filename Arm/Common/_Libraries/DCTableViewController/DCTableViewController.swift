//
//  DCTableViewController.swift
//  Rednote
//
//  Created by Dan Cech on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

class DCTableViewController: UITableViewController, DCTableViewHandling {
    
    var tableStructures: [Int: DCTableViewStructure<CellDescription, SectionDescription>] = [:]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return protocolNumberOfSectionsInTableView(tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return protocolTableView(tableView, numberOfRowsInSection: section)
    }
    
    ////////////////////////////////////////////////////////////////
    // Custom cell setup steps

    func tableView(
        _ tableView: UITableView,
        willUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription) {
        // Rewrite in descendants
    }
    
    func tableView(
        _ tableView: UITableView,
        didUpdateCell cell: UITableViewCell,
        cellDescription: CellDescription) {
        // Rewrite in descendants
    }
 
    ////////////////////////////////////////////////////////////////
    // Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForRowAtIndexPath: indexPath, cellDescription: nil)
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAtIndexPath indexPath: IndexPath,
        cellDescription: CellDescription?) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        
        let cellDescription = cellDescription ?? self.tableView(tableView, descriptionForCellAtIndexPath: indexPath, currentState: true)
        
        if let unwrappedCellDescription = cellDescription {
            let cellTypeIdentifier = unwrappedCellDescription.cellType.stringValue()!
            cell = tableView.dequeueReusableCell(withIdentifier: cellTypeIdentifier, for: indexPath)
            
            self.tableView(tableView, willUpdateCell: cell!, cellDescription: unwrappedCellDescription)
            
            if let cellProtocol = cell as? DCTableViewCellProtocol {
                if let unwrappedViewModel = unwrappedCellDescription.viewModel {
                    cellProtocol.updateCell(viewModel: unwrappedViewModel, delegate: unwrappedCellDescription.delegate)
                }
            }
            
            self.tableView(tableView, willUpdateCell: cell!, cellDescription: unwrappedCellDescription)
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return protocolTableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return protocolTableView(tableView, heightForRowAt: indexPath)
    }
    
    ////////////////////////////////////////////////////////////////
    // Header
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return protocolTableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return protocolTableView(tableView, heightForHeaderInSection: section)
    }
    
    ////////////////////////////////////////////////////////////////
    // Footer
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return protocolTableView(tableView, titleForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return protocolTableView(tableView, heightForFooterInSection: section)
    }
    
    ////////////////////////////////////////////////////////////////
    // Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        protocolTableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        protocolTableView(tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
}
