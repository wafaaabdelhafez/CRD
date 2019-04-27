//
//  EditViewController.swift
//  CRD
//
//  Created by wafaa on 4/22/19.
//  Copyright © 2019 Orange. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet var firstNameLabel: UITextField!
    @IBOutlet var lastNameLabel: UITextField!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var deleteButton: UIButton!
    
    var requester = Requester()
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    var countryCode: String!
    var accessToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        editButton.isHidden = true
        deleteButton.isHidden = true
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        phoneNumberLabel.text = countryCode.uppercased() + " " + phoneNumber
    }

    
    private func editUser(accessToken: String){
        var json = [String : Any] ()
        json ["firstName"] = firstName
        json ["lastName"] = lastName
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let headers = ["Authorization": accessToken]
            requester.request(url: CRDApi.accountPersonalURL, method: "PUT", body: data, headers: headers) {
                (result) -> Void in
                print("Success: \(String(data: result, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
                self.firstNameLabel.textColor = UIColor.green
                self.lastNameLabel.textColor = UIColor.green
            }
        } catch {
            print ("Cannot create json body!")
        }
    }
    
    private func searchForNumber(url: URL){
        requester.request(url: url, method: "GET", body: nil, headers: nil) {
            (result) -> Void in
            print("Success: \(String(data: result, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
            self.editButton.isHidden = false
            self.deleteButton.isHidden = false
        }
        
    }
    
    @IBAction func onSearchPressed(_ sender: Any) {
        let components = phoneNumber.components(separatedBy: "-")
        let code = components[0]
        let number = components[1]
        let url = CRDApi.checkExist.absoluteString + "/" + code + "/" + number
        searchForNumber(url: (URLComponents(string: url)?.url)!)
    }
    
    @IBAction func onEditPressed(_ sender: Any) {
        editUser(accessToken: accessToken)
    }
    
    
    @IBAction func onDeletePressed(_ sender: Any) {
        deleteUser()
    }
    
    private func deleteUser(){
        let headers = ["Authorization": accessToken!]
        requester.request(url: CRDApi.accountPersonalURL, method: "DELETE", body: nil, headers: headers){
            (result) -> Void in
            print("Success: \(String(data: result, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
        }
    }
    
}
