//
//  UserSql.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 09/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import Foundation

extension User {
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (USER_ID TEXT PRIMARY KEY, USER_NAME TEXT, ABOUT TEXT, IMAGE_URL TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE USERS;", nil, nil, &errormsg);
        if(res != 0){
            print("error dropping table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[User]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [User]()
        if (sqlite3_prepare_v2(database,"SELECT * from USERS;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let about = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let image = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                
                data.append(User(_id:stId, _name:name, _about:about, _image:image))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, user:User){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO USERS(USER_ID, USER_NAME, ABOUT, IMAGE_URL) VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = user.id.cString(using: .utf8)
            let name = user.name.cString(using: .utf8)
            let about = user.about.cString(using: .utf8)
            let image = user.image.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, about,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, image,-1,nil);
            
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->User?{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [User]()
        
        if (sqlite3_prepare_v2(database,"SELECT * from USERS WHERE USER_ID = ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            let id = byId.cString(using: .utf8)
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let name = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let about = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let image = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                
                data.append(User(_id:stId, _name:name, _about:about, _image:image))
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
        
        if (data.count > 0)
        {
            return data[0]
        }
        
        return nil;
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "users")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tabeName: "users", date: date);
    }
}
