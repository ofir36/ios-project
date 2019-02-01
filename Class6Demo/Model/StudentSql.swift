//
//  StudentSql.swift
//  Class6Demo
//
//  Created by Studio on 28/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import Foundation

extension Student{
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS STUDENTS (ST_ID TEXT PRIMARY KEY, NAME TEXT, PHONE TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE STUDENTS;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[Student]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Student]()
        if (sqlite3_prepare_v2(database,"SELECT * from STUDENTS;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let phone = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                data.append(Student(_id:stId, _name:name,  _phone:phone))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, student:Student){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO STUDENTS(ST_ID, NAME, PHONE) VALUES (?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = student.id.cString(using: .utf8)
            let name = student.name.cString(using: .utf8)
            let phone = student.phone.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, phone,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->Student?{
        
        return nil;
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "students")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tabeName: "students", date: date);
    }
}
