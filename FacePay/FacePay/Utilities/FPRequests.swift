//
//  FPRequests.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import UIKit
import Foundation
import AWSS3

class FPRequests {
    
    static let sharedInstance = FPRequests()
    let transferManager = AWSS3TransferManager.default()
    var tempKeyName: String?
    
    func uploadImageToAWS(image: UIImage, _ completion: @escaping (String)->Void) {
        tempKeyName = String(arc4random()) + ".png"
        let uploadingFileURL = storeImage(image: image)
        let bucket = "facepaydemobucket1234567890"
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest?.bucket = bucket
        uploadRequest?.key = tempKeyName
        uploadRequest?.body = uploadingFileURL
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(uploadRequest?.key ?? "") Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(uploadRequest?.key ?? "") Error: \(error)")
                }
                //self.removeImage(url: stringURL)
                return nil
            }
            
            let fileurl = "https://s3.amazonaws.com/" + bucket + "/" + self.tempKeyName!
            print(fileurl)
            completion(fileurl)
            return nil
        })
    }
    
    //username, password
    func logIn(_ username: String, _ password: String, _ completion: @escaping (Bool) -> Void) {
        let jsonDict: [String : String] = ["username" : username, "password" : password]
        
        let request = buildRequest(jsonDict: jsonDict)!
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(UserLogIn.self, from: data)
                    
                    let currentUser = CurrentUser(accountID: user.account_id, balance: user.balance)
                    FPVariablesManager.sharedInstance.currentUser = currentUser
                    
                    let defaults = UserDefaults.standard
                    defaults.set(user.account_id, forKey: DefaultsKeys.accountSecret)
                    defaults.synchronize()
                    
                    completion(true)
                } catch {
                    print(error)
                }
                completion(false)
            }
            }.resume()
    }
    
    
    func signUp(username: String, password: String, firstName: String, lastName: String, city: String, email: String, _ completion: @escaping (Bool) -> Void) {
        let jsonDict: [String : String] = ["username" : username, "password" : password, "first_name" : firstName, "last_name" : lastName, "city" : city, "primary_email" : email]
        
        let request = buildRequest(jsonDict: jsonDict)!
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(UserSignUp.self, from: data)
                    
                    let currentUser = CurrentUser(accountID: user.account_id, balance: user.balance)
                    FPVariablesManager.sharedInstance.currentUser = currentUser
                    
                    let defaults = UserDefaults.standard
                    defaults.set(user.account_id, forKey: DefaultsKeys.accountSecret)
                    defaults.synchronize()
                    
                    print (user.account_id)
                    completion(true)
                } catch {
                    print(error)
                }
            }
            completion(false)
            }.resume()
    }
    
    private func buildRequest(jsonDict: [String: Any]) -> URLRequest? {
        guard let url = URL(string: "http://10.66.182.232:8080/v1/session") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return nil }
        request.httpBody = httpBody
        return request
    }
    
    private func storeImage(image: UIImage) -> URL {
        if let data = UIImagePNGRepresentation(image) {
            
            let filename = getDocumentsDirectory().appendingPathComponent(tempKeyName!)
            try? data.write(to: filename)
            return filename
        }
        return URL(string: "")!
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func removeImage(url: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: url)
        }
        catch {
            print("removing", error)
        }
    }
}
