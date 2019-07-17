//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Serhii CHORNONOH on 7/10/19.
//  Copyright © 2019 Serhii CHORNONOH. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    let auth = AuthRequest()
    var jsonData : JSON?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loginTextField.delegate = self

        searchButton.layer.cornerRadius = 10
        
        auth.getToken()
        
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if !loginTextField.text!.isEmpty {
            let login = loginTextField.text?.replacingOccurrences(of: " ", with: "")
            guard login!.containsSpecialCharacter == false else {
                self.presentErrorAlert("Error", "Not valid symbol(s)")
                loginTextField.text = ""
                return }
            auth.checkUser(user: login!) { completion in
                if completion != nil {
                    self.jsonData = completion
                    self.performSegue(withIdentifier: "userProfileSegue", sender: nil)
                } else {
                    self.presentErrorAlert("Error", "Login does not exists")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchButtonAction(textField)
        return true
    }
    
    func presentErrorAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userProfileSegue" {
            let fillData = segue.destination as! SecondViewController
//            fillData.jsonData = jsonData
            fillData.profileData = ProfileData(json: jsonData!)
            
        }
    }
    

}

extension String {
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
}
