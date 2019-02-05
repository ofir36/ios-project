//
//  PostSql.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 04/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import Foundation

extension Post{
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (POST_ID TEXT PRIMARY KEY, POST_TEXT TEXT, POST_DATE DOUBLE, USER_ID TEXT, IMAGE_URL TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE POSTS;", nil, nil, &errormsg);
        if(res != 0){
            print("error dropping table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[Post]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        if (sqlite3_prepare_v2(database,"SELECT * from POSTS;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let stId = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let text = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
//                let date = Double(sqlite3_column_double(sqlite3_stmt, 2))
                let userId = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let image = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)

                data.append(Post(_id:stId, _text:text, _userId:userId, _image:image))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(POST_ID, POST_TEXT, POST_DATE, USER_ID, IMAGE_URL) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = post.id.cString(using: .utf8)
            let text = post.text.cString(using: .utf8)
            let userId = post.userId.cString(using: .utf8)
            let image = post.image.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, text,-1,nil);
            sqlite3_bind_double(sqlite3_stmt, 3, 0)
            sqlite3_bind_text(sqlite3_stmt, 4, userId,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, image,-1,nil);

            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->Post?{
        
        return nil;
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "posts")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tabeName: "posts", date: date);
    }
}
