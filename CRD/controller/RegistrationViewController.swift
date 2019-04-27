//
//  ViewController.swift
//  CRD
//
//  Created by wafaa on 4/17/19.
//  Copyright © 2019 Orange. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    var requester = Requester()
    
    @IBOutlet var firstNameLabel: UITextField!
    @IBOutlet var lastNameLabel: UITextField!
    
    @IBOutlet var countryCodeLabel: UITextField!
    @IBOutlet var phoneNumberLabel: UITextField!
    
    var verificationToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func onCountinuePlressed(_ sender: Any) {
    
        let countryCode = countryCodeLabel.text
        let phoneNumber = phoneNumberLabel.text
        
        var json = [String : Any] ()
        json ["countryCode"] = countryCode?.uppercased()
        json ["phoneNumber"] = phoneNumber
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            requester.request(url: CRDApi.accountPersonalURL, method: "POST", body: data, headers: nil){ (result) -> Void in
                print("Success: \(String(data: result, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
                self.processResult(fromJSON: result)
                self.performSegue(withIdentifier: "goToSmsVerification", sender: self)
            }
        } catch {
            print ("Cannot create json body!")
        }
        
    }
    
    private func processResult(fromJSON data:Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonDictionary = jsonObject as? [AnyHashable: Any]
            self.verificationToken = jsonDictionary? ["verificationToken"] as? String
            print("verificationToken\(String(describing: verificationToken))")
        } catch {
            print ("Cannot create json body!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSmsVerification" {
            let smsVerificationScreen = segue.destination as! SmsVerificationViewController
            smsVerificationScreen.firstName = firstNameLabel.text
            smsVerificationScreen.lastName = lastNameLabel.text
            smsVerificationScreen.verificationToken = self.verificationToken
            smsVerificationScreen.phoneNumber = phoneNumberLabel.text
            smsVerificationScreen.countryCode = countryCodeLabel.text
        }
    }
    
    
    
}

