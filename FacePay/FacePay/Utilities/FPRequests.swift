//
//  FPRequests.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation

class FPRequests {
    func requestCustomerJSON(customer: String) {
        let urlString = CapitalOneAPIKeys.baseURL + "/customers" + "/" + customer + "/accounts?key=" + CapitalOneAPIKeys.appID
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                guard let data = data else { return }
                
                do {
                    let users = try
                        JSONDecoder().decode([User].self, from: data)
                    users.forEach {print($0._id)}
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
}
