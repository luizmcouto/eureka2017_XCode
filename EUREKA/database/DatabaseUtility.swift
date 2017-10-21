//
//  DatabaseUtility.swift
//  EUREKA
//
//  Created by Roberta Neves Marchetti do Couto on 13/09/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import Foundation

class Utility {
    
    class func getPath(_ fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(_ fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            var error : NSError?
            
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            
            if (error != nil) {
                print("Error Occured")
                print(error?.localizedDescription)
            } else {
                print("Successfully Copy")
                print("Your database copy successfully")
            }
        }
    }
}
