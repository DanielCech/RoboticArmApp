//
//  DCSectionDescription.swift
//  Rednote
//
//  Created by Dan Cech on 22.03.16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit

////////////////////////////////////////////////////////////////
// Protocols

protocol SectionDescribing {
    
    var sectionID: IntConvertibleProtocol { get set }
    var viewModel: Any? { get set }
    
    var headerTitle: String? { get set }
    var headerHeight: ((_ sectionDescription: Self, _ section: Int) -> CGFloat)? { get set }
    
    var footerTitle: String? { get set }
    var footerHeight: ((_ sectionDescription: Self, _ section: Int) -> CGFloat)? { get set }

}

////////////////////////////////////////////////////////////////
// Structs

struct SectionDescription: SectionDescribing {
    var sectionID: IntConvertibleProtocol
    var viewModel: Any?
    
    var headerTitle: String?
    var headerHeight: ((_ sectionDescription: SectionDescription, _ section: Int) -> CGFloat)?
    var estimatedHeaderHeight: ((_ sectionDescription: SectionDescription, _ section: Int) -> CGFloat)?
    
    var footerTitle: String?
    var footerHeight: ((_ sectionDescription: SectionDescription, _ section: Int) -> CGFloat)?
    
    init(
        sectionID: Int,
        viewModel: Any? = nil,
        
        headerTitle: String? = nil,
        headerHeight: ((_ sectionDescription: SectionDescription, _ section: Int) -> CGFloat)? = nil,
        
        footerTitle: String? = nil,
        footerHeight: ((_ sectionDescription: SectionDescription, _ section: Int) -> CGFloat)? = nil
        ) {
        self.sectionID = sectionID
        self.viewModel = viewModel
        
        self.headerTitle = headerTitle
        self.headerHeight = headerHeight
        
        self.footerTitle = footerTitle
        self.footerHeight = footerHeight
    }
}
