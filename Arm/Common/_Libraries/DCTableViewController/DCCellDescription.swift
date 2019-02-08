//
//  DCCellDescription.swift
//  Rednote
//
//  Created by Dan Cech on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit


protocol CellTypeProtocol {
    func stringValue() -> String!
}

protocol CellTypeDescribing: CellTypeProtocol, RawRepresentable { }

extension CellTypeDescribing {
    func stringValue() -> String! {
        if let string = self.rawValue as? String {
            return string.prefix(1).uppercased() + string.dropFirst()           // Capitalize first letter
        }
        else {
            return nil
        }
    }
}


protocol IntConvertibleProtocol {
    func intValue() -> Int!
}

protocol IntConvertible: IntConvertibleProtocol, RawRepresentable { }

extension CellTypeDescribing {
    func intValue() -> Int! {
        if let integer = self.rawValue as? Int {
            return integer
        }
        else {
            return nil
        }
    }
}

extension Int: IntConvertibleProtocol {
    func intValue() -> Int! {
        return self
    }
}

////////////////////////////////////////////////////////////////
// Protocols

protocol CellDescribing {
    
    var cellID: IntConvertibleProtocol? { get set }
    var cellType: CellTypeProtocol { get set }
    var viewModel: Any? { get set }
    var delegate: AnyObject? { get set }
    var cellHeight: ((_ cellDescription: Self, _ indexPath: IndexPath) -> CGFloat)? { get set }
    var estimatedCellHeight: ((_ cellDescription: Self, _ indexPath: IndexPath) -> CGFloat)? { get set }
    
    var didSelectCell: ((_ cell: UITableViewCell, _ cellDescription: Self, _ indexPath: IndexPath) -> Void)? { get set }
    var didDeselectCell: ((_ cell: UITableViewCell, _ cellDescription: Self, _ indexPath: IndexPath) -> Void)? { get set }
}

////////////////////////////////////////////////////////////////
// Structs

public struct CellDescription: CellDescribing {
    
    var cellID: IntConvertibleProtocol?
    var cellType: CellTypeProtocol
    var viewModel: Any?          //viewModel for cell is any associated value with cell, it can be number, string or class/struct
    weak var delegate: AnyObject?
    var cellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)?
    var estimatedCellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)?
    
    var didSelectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> Void)?
    var didDeselectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> Void)?
    
    init(
        cellID: Int? = nil,
        cellType: CellTypeProtocol,
        viewModel: Any? = nil,
        delegate: AnyObject? = nil,
        cellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)? = nil,
        estimatedCellHeight: ((_ cellDescription: CellDescription, _ indexPath: IndexPath) -> CGFloat)? = nil,
        didSelectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> Void)? = nil,
        didDeselectCell: ((_ cell: UITableViewCell, _ cellDescription: CellDescription, _ indexPath: IndexPath) -> Void)? = nil) {
        self.cellID = cellID
        self.cellType = cellType
        self.viewModel = viewModel
        self.delegate = delegate
        self.cellHeight = cellHeight
        self.estimatedCellHeight = estimatedCellHeight
        self.didSelectCell = didSelectCell
        self.didDeselectCell = didDeselectCell
    }
}
