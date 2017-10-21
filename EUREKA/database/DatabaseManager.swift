//
//  ModelManager.swift
//  EUREKA
//
//  Created by Roberta Neves Marchetti do Couto on 13/09/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import Foundation

class DatabaseManager {
    
    static let sharedInstance = DatabaseManager()
    
    var database: FMDatabase?
    
    fileprivate init() {
        database = FMDatabase(path: Utility.getPath("EUREKA.db"))
    }
    
}
