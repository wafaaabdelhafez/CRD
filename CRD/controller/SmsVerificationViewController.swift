//
//  SmsVerificationViewController.swift
//  CRD
//
//  Created by wafaa on 4/22/19.
//  Copyright © 2019 Orange. All rights reserved.
//

import UIKit

class SmsVerificationViewController: UIViewController {
    
    @IBOutlet var smsVerificationCode: UITextField!
    @IBOutlet var editButton: UIButton!
    
    var requester = Requester()
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    var countryCode: String!
    var verificationToken: String!
    var accessToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        editButton.isHidden = true
    }
    
    @IBAction func onVerifyPressed(_ sender: UIButton) {
        
        var json = [String : Any] ()
        json ["pin"] = smsVerificationCode.text
        json ["verificationToken"] = verificationToken
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            requester.request(url: CRDApi.smsVerification, method: "PUT", body: data, headers: nil) {
                (result) -> Void in
                print("Success: \(String(data: result, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
                self.processResult(fromJSON: result)
                self.createUser(accessToken: self.accessToken)
            }
        } catch {
            print ("Cannot create json body!")
        }
    }
    
    private func processResult(fromJSON data:Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonDictionary = jsonObject as? [AnyHashable: Any]
            accessToken = jsonDictionary? ["accessToken"] as? String
        } catch {
            print ("Cannot create json body!")
        }
    }
    
    private func createUser(accessToken: String){
        var json = [String : Any] ()
        json ["firstName"] = firstName
        json ["lastName"] = lastName
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let headers = ["Authorization": accessToken]
            requester.request(url: CRDApi.accountPersonalURL, method: "PUT", body: data, headers: headers) {
                (result) -> Void in
                print("Success: \(String(data: result, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
                self.editButton.isHidden = false
            }
        } catch {
            print ("Cannot create json body!")
        }
    }
    
    @IBAction func onEditPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let editScreen = segue.destination as! EditViewController
            editScreen.firstName = firstName
            editScreen.lastName = lastName
            editScreen.phoneNumber = phoneNumber
            editScreen.countryCode = countryCode
            editScreen.accessToken = accessToken
        }
    }
    
}
