//
//  CRDApi.swift
//  CRD
//
//  Created by wafaa on 4/17/19.
//  Copyright © 2019 Orange. All rights reserved.
//

import Foundation

public enum Method: String {

    case ACCOUNT_PERSONAL = "/v1/account/personal"
    case USER_LOGIN = "/v1/user/login/personal"
    case SMS_VERIFICATION = "/v1/account/personal/verify"
    case CHECK_EXIST = "/v1/account/personal/checkExists"
    
}

enum FlickerError: Error {
    case invalidJSONData
}

struct CRDApi {
    
    private static let baseURLString = "https://crd-testing-manual.ole-lab.com/api"
    private static let dateFormatter: DateFormatter = {
        let formetter = DateFormatter()
        formetter.dateFormat = "yy-MM-dd HH:mm:ss"
        return formetter
    }()
    
    private static func CRDURL(method: Method , parameters: [String:String]?) -> URL{
        let components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
        ]
        
        for(key, value) in baseParams{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let addetionalParams = parameters{
            for(key, value) in addetionalParams{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
//        components.queryItems = queryItems
        return components.url!
    }
    
    static func response(fromJSON data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            print(jsonObject)
        } catch let error {
            print("Error while request \(error)")
        }
    }
    
    static var accountPersonalURL: URL {
        return (URLComponents(string: baseURLString + Method.ACCOUNT_PERSONAL.rawValue)?.url)!
    }
    
    static var smsVerification: URL {
        return (URLComponents(string: baseURLString + Method.SMS_VERIFICATION.rawValue)?.url)!
    }
    
    static var checkExist: URL {
        return (URLComponents(string: baseURLString + Method.CHECK_EXIST.rawValue)?.url)!
    }

    
}
