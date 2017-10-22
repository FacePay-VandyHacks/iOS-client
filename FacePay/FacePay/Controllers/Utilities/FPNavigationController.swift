//
//  FPNavigationController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/22/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = Colors.FPGreen
        let font = UIFont(name: "Avenir Next", size: 20 )!
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.FPBlue, NSAttributedStringKey.font: font]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        self.navigationBar.barTintColor = UIColor.white
    }
}
