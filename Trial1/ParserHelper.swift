//
//  ParserHelper.swift
//  Trial1
//
//  Created by Jaya   on 08/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ParserHelper {
    
    static let instance = ParserHelper()
    
    func parsePodCastItems(data : Data, completionHandler:(([PodCast]) -> Void)) {
        
        var finalArray:[PodCast] = []
        
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
        
        let resultsArray = json?["results"] as! NSArray
        
        let resultCount = json?["resultCount"] as AnyObject
        
        print("resultCount \(resultCount)")
        
        for index in resultsArray {
            
            let podCast = PodCast()
            
            let jsonObject = index as AnyObject
                        
            podCast.artistName = jsonObject["artistName"] as? String
            
            podCast.collectionName = jsonObject["collectionName"] as? String
            
            podCast.trackName = jsonObject["trackName"] as? String
            
            podCast.previewUrl = jsonObject["previewUrl"] as? String
            
            podCast.artworkUrl100 = jsonObject["artworkUrl100"] as? String
        
            finalArray.append(podCast)
            
            print(podCast)
            
        }
        completionHandler(finalArray)
        
        print(finalArray)
        
    }
    

}
