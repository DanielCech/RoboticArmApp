//
//  ProgramCell.swift
//  Arm
//
//  Created by Dan on 28.09.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

class ProgramCell: UITableViewCell, ReusableView, DCTableViewCellProtocol {

    @IBOutlet weak var _titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(viewModel: Any, delegate: Any?) {
        guard let cellViewModel = viewModel as? ProgramCellViewModel else { return }
        
        _titleLabel.text = cellViewModel.name
    }
}
