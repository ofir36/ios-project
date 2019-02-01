//
//  ModelSql.swift
//  Class6Demo
//
//  Created by Studio on 28/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import Foundation

class ModelSql {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            //dropTables()
            createTables()
        }
        
    }
    
    func createTables() {
        Student.createTable(database: database);
        LastUpdateDates.createTable(database: database);
    }
    
    func dropTables(){
        Student.drop(database: database)
        LastUpdateDates.drop(database: database)
    }
    
    
}





