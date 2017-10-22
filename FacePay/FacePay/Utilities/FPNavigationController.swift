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
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.FPBlue]
        self.navigationBar.barTintColor = UIColor.white
    }
}
