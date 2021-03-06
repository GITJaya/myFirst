//
//  Utility.swift
//  Trial1
//
//  Created by Jaya   on 10/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class Utility {
    
    class func getDocumentDirectoryURL()->URL{
        var documentDirectoryURL : URL? = nil
        do {
            documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
        } catch {
            print("Unable to fetch documentDirectoryURL")
        }
        return documentDirectoryURL!
    }
    
}
