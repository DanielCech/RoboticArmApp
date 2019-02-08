//
//  ProgramsViewController.swift
//  ArmView
//
//  Created by Dan on 26.05.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

class ProgramsViewController: DCTableSupportedViewController {

    @IBOutlet weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tabBarItem.selectedImage = UIImage(named: "Icon-Source")!.withRenderingMode(.alwaysOriginal)
        
        _initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    ////////////////////////////////////////////////////////////////
    // MARK: - Table View Management
    
    private func _initTableView() {
        do {
            try registerTableView(_tableView)
        }
        catch {
            print("Registration error")
        }
        
        _tableView.registerCellNib(ProgramCell.self)
        
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 70
        
        createDataSourceForTable(_tableView)
        _tableView.reloadData()
    }

    
    func createDataSourceForTable(_ tableView: UITableView) {
        super.createDataSourceForTable(tableView)
        
        let sectionDescription = SectionDescription(
            sectionID: 0,
            headerHeight: { _, _ in 0.01 },
            footerHeight: { _, _ in 0.01 }
        )
        
        let sectionCells: [CellDescription] = [
            CellDescription(
                cellID: 0,
                cellType: TableCellType.programCell,
                viewModel: ProgramCellViewModel(name: "First")
            ),
            CellDescription(
                cellID: 1,
                cellType: TableCellType.programCell,
                viewModel: ProgramCellViewModel(name: "Second")
            )
            ]
        
        self.tableView(_tableView, addSection: sectionDescription, withCells: sectionCells)
        
    }
}
