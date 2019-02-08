//
//  TabBarViewController.swift
//  Arm
//
//  Created by Dan on 19.06.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        tabBarItem.selectedImage = UIImage(named: "Icon-Robot")!.withRenderingMode(.alwaysOriginal)

//        guard let tabBar = tabBarController?.tabBar else { return }

        for item in tabBar.items! {
            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            //item.image = item.image?.withRenderingMode(.alwaysOriginal)
        }
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
