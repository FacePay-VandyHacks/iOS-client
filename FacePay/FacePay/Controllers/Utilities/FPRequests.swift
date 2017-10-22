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
    
    //Upload the image to AWS S3 to use in processing for Kairos
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
            completion(fileurl)
            return nil
        })
    }
    
    //Pays the user with the username specified the amount specified
    func sendRequestHandle(_ handle: String,_ amount: Double, _ completion: @escaping (Bool) -> Void) {
        let accountID = (FPVariablesManager.sharedInstance.currentUser?.accountID)!
        
        let jsonDict: [String:String] = ["handle" : handle, "accountID" : accountID]
        let request = buildRequest(jsonDict: jsonDict)!
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(error)
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(Balance.self, from: data)
                    
                    let currentUser = CurrentUser(accountID: accountID, balance: user.balance)
                    FPVariablesManager.sharedInstance.currentUser = currentUser
                    
                    completion(true)
                } catch {
                    print(error)
                }
                completion(false)
            }
            }.resume()
    }
    
    //Pays the user captured at the fileURL the amount specified
    func sendRequest(_ username: String,_ amount: Double,_ completion: @escaping (Bool) -> Void) {
        let accountID = (FPVariablesManager.sharedInstance.currentUser?.accountID)!

        let jsonDict: [String:String] = ["username" : username, "account_id" : accountID]
        guard let url = URL(string: "http://10.66.182.232:8080/v1/paymentHandle") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return}
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(error)
            if let response = response {
                print(response)
            }

            if let data = data {
                do {
                    let user = try JSONDecoder().decode(Balance.self, from: data)

                    let currentUser = CurrentUser(accountID: accountID, balance: user.balance)
                    FPVariablesManager.sharedInstance.currentUser = currentUser

                    completion(true)
                } catch {
                    print(error)
                }
                completion(false)
            }
            }.resume()
    }
    
    //Gets the balance of the current user
    func getBalance(_ completion: @escaping (Bool) -> Void) {
        let accountID = (FPVariablesManager.sharedInstance.currentUser?.accountID)!
        let urlString = "http://api.reimaginebanking.com/customers/" + accountID + "/accounts?key=3dc98b7092849aee4831c2d8a79b4b89"
        
        let url = URL(string: urlString)!
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            print(error)
            if let data = data {
                do {
                    let balance = try JSONDecoder().decode([Balance].self, from: data)
                    FPVariablesManager.sharedInstance.currentUser = CurrentUser(accountID: accountID, balance: balance[0].balance)
                    completion(true)
                } catch {
                    print(error)
                }
                completion(false)
            }
            completion(false)
            }.resume()
    }
    
    //Enrolls the image into Kairos db
    func enrollKairosImage(_ fileUrl: String, _ username: String, _ completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://api.kairos.com/enroll")!
        
        let jsonDict: [String : String] = ["image" : fileUrl, "subject_id" : username, "gallery_name" : "gallery1"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(KairosAPI.AppID, forHTTPHeaderField: "app_id")
        request.addValue(KairosAPI.AppKey, forHTTPHeaderField: "app_key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { completion(false); return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            completion(error == nil)
        }.resume()
    }
    
    
    
    func checkKairosUser(_ fileUrl: String, _ completion: @escaping (KairosRecognized?) -> Void) {
        let url = URL(string: "https://api.kairos.com/recognize")!
        
        let jsonDict: [String : String] = ["image" : fileUrl, "gallery_name" : "gallery1"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(KairosAPI.AppID, forHTTPHeaderField: "app_id")
        request.addValue(KairosAPI.AppKey, forHTTPHeaderField: "app_key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { completion(nil); return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        if let images = json["images"] as? [Any] {
                            if let image = images[0] as? [String: Any] {
                                if let transaction = image["transaction"] as? [String : Any]{
                                    guard let confidence = transaction["confidence"] as? Double else { completion(nil); return}
                                    guard let subjectID = transaction["subject_id"] as? String else { completion(nil); return}
                                    let object = KairosRecognized(confidence: confidence, subject_id: subjectID)
                                    completion(object)
                                }
                            }
                        }
                    }
                    completion(nil)
                } catch {
                    print(error)
                }
            }
            completion(nil)
            }.resume()
    }
    
    //Log in the user
    func logIn(_ username: String, _ password: String, _ completion: @escaping (Bool) -> Void) {
        let jsonDict: [String : String] = ["username" : username, "password" : password]
        
        let request = buildRequest(jsonDict: jsonDict)!
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(error)
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
    
    //Sign up the user
    func signUp(username: String, password: String, firstName: String, lastName: String, city: String, email: String, _ completion: @escaping (Bool) -> Void) {
        let jsonDict: [String : String] = ["username" : username, "password" : password, "first_name" : firstName, "last_name" : lastName, "city" : city, "primary_email" : email]
        
        let url = URL(string: "http://10.66.182.232:8080/v1/user")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else {
            completion(false)
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(error)
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    print("decoding")
                    let user = try JSONDecoder().decode(UserSignUp.self, from: data)
                    print("decoded")
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
    
    private func buildRequest(jsonDict: [String: String]) -> URLRequest? {
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
