//
//  DocumentsDirectory.swift
//  Trial1
//
//  Created by Jaya   on 22/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

enum SwitchItems{
    case podCast,MusicPlayer
}

class DocumentsDirectory {

  
    
    class func getDirectoryPath() -> URL {
        
        var documentsDirectoryURL : URL? = nil
        do {
          documentsDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(documentsDirectoryURL)
            createDirectory(directoryType: SwitchItems.podCast)
            
        } catch { }
        
        return documentsDirectoryURL!
    }
  
    class func createDirectory(directoryType: SwitchItems)-> String{
        
        let fileManager = FileManager.default
        var paths: String
        
        let documentsDirectoryURL = getDirectoryPath()
        switch directoryType{
        case .podCast:
            paths = String(describing: documentsDirectoryURL.appendingPathComponent("PodCast"))
        case .MusicPlayer:
            paths = String(describing: documentsDirectoryURL.appendingPathComponent("MusicPlayer"))
        }
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
        return paths
    }

}
