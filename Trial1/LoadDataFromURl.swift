
//
//  LoadJson.swift
//  Trial1
//
//  Created by Jaya   on 08/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class LoadDataFromURl {
    
    static let instance = LoadDataFromURl()
    
    func getData(urlString:String,completion: @escaping (_ result: Data) -> Void) {
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        let url = URL(string:urlString)
        
        dataTask = defaultSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            
        
            if let error = error {
                print(error.localizedDescription)
                
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(data!)
                }
            }
        })
        dataTask?.resume()
    }
}


