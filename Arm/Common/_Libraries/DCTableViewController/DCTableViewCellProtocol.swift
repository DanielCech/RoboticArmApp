//
//  DCTableViewCellProtocol.swift
//  DCTableViewController
//
//  Created by Dan Cech on 11.09.16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit

protocol DCTableViewCellProtocol {
    
    func updateCell(viewModel: Any, delegate: Any?)
}

extension DCTableViewCellProtocol {
    
    func updateCell(viewModel: Any, delegate: Any? = nil) {
        // Implement in derived cells
    }
}
