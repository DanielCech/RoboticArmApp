//
//  ProgramsViewController.swift
//  ArmView
//
//  Created by Dan on 26.05.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

class ProgramsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tabBarItem.selectedImage = UIImage(named: "Icon-Source")!.withRenderingMode(.alwaysOriginal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
