//
//  FPJSONModels.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/21/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

//username:       newUser.username,
//primary_email:  newUser.primary_email,
//account_id:     newUser.account_id,
//balance:        personalBalance
struct UserSignUp : Decodable {
    let username: String
    let primary_email: String
    let account_id: String
    let balance: Double
}

struct UserLogIn : Decodable {
    let username: String
    let primary_email: String
    let account_id: String
    let balance: Double
}

struct CurrentUser {
    let accountID: String
    let balance: Double
}
