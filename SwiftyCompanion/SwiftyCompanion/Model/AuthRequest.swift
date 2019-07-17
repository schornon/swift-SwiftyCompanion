//
//  AuthRequest.swift
//  SwiftyCompanion
//
//  Created by Serhii CHORNONOH on 7/10/19.
//  Copyright © 2019 Serhii CHORNONOH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AuthRequest: NSObject {

    let TOKEN_URL = "https://api.intra.42.fr/oauth/token"
    let PARAMS = [
        "grant_type" : "client_credentials",
        "client_id" : "18dd715d9ff9b86e37c9e326a0f2a82a8b0022f1442c5a5c267d2e3e02a9cfce",
        "client_secret" : "7394ba83c869b160e338282bea6a069241a0a4b4f4d6b693de681cbd49cfab8d"
    ]
    var token = ""
    
    func getToken() {
        let verify = UserDefaults.standard.object(forKey: "token")
        if verify == nil {
            Alamofire.request(TOKEN_URL, method: .post, parameters: PARAMS).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else { return }
                    let json = JSON(value)
                    self.token = json["access_token"].stringValue
                    UserDefaults.standard.set(self.token, forKey: "token")
                    print("token : ", self.token)
                self.checkToken()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            self.token = verify as! String
            checkToken()
        }
        
    }
    
    private func checkToken() {
        let bearer = "Bearer \(self.token)"
        let tmpUrl = URL(string: "https://api.intra.42.fr/oauth/token/info")
        var request = URLRequest(url: tmpUrl!)
        request.httpMethod = "GET"
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        Alamofire.request(request).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let value = response.result.value else { return }
                let json = JSON(value)
                print("Expire in: \(json["expires_in_seconds"]) sec.")
            case .failure(let error):
                UserDefaults.standard.removeObject(forKey: "token")
                print("Error. Not valid token", error)
                self.getToken()
            }
        }
    }
    
    func checkUser(user: String, completion: @escaping (JSON?) -> Void) {
        let bearer = "Bearer \(self.token)"
        guard user.containsSpecialCharacter == false else { return }
        let userUrl = URL(string: "https://api.intra.42.fr/v2/users/" + user)
        var request = URLRequest(url: userUrl!)
        request.httpMethod = "GET"
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        Alamofire.request(request).validate().responseJSON { response in
            switch response.result {
            case .success:
                guard let value = response.result.value else { return }
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                completion(nil)
                print("Error. Login does not exists", error)
            }
        }
    }
    
}
