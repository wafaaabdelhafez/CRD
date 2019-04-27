//
//  Requester.swift
//  CRD
//
//  Created by wafaa on 4/17/19.
//  Copyright © 2019 Orange. All rights reserved.
//

import Foundation

public class Requester {
    
    private let session : URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func request (url: URL, method: String, body: Data?, headers: [String:String]?, completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let extraHeaders = headers {
            for(key, value) in extraHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        print("url: \(url)")
        print("method: \(method)")
        if let body = body {
            print("body: \(String(data: body, encoding: String.Encoding.utf8) ?? "Data could not be printed")")
        }
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            print("Headers: \(String(describing: httpResponse?.allHeaderFields))")
            print("Status Code: \(String(describing: httpResponse?.statusCode))")
            OperationQueue.main.addOperation {
                if httpResponse?.statusCode == 200 {
                    completion(data!)
                } else {
                    print("Error: \(error.debugDescription)")
                }
            }
        }
        
        task.resume()
    }
    
    
    
}
