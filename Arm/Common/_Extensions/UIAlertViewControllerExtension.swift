//
//  UIAlertViewControllerExtension.swift
//  Arm
//
//  Created by Dan on 08.05.2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import Foundation

public extension UIAlertController {
    class func show(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        alert.show()
    }
    
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
