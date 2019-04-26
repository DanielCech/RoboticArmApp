//
//  SourceCodeViewController.swift
//  Arm
//
//  Created by Dan on 26.04.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

class SourceCodeViewController: UIViewController, Identifiable {

    @IBOutlet weak var textView: UITextView!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = text
    }
    
    func showText(text: String) {
        self.text = text
    }
}
