//
//  Student.swift
//  Class6Demo
//
//  Created by Studio on 21/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import Foundation
import Firebase

class Student {
    let id:String
    let name:String
    let phone:String
    let url:String
    var lastUpdate:Double?

    init(_id:String, _name:String, _phone:String = "", _url:String = ""){
        id = _id
        name = _name
        phone = _phone
        url = _url
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        name = json["name"] as! String
        phone = json["phone"] as! String
        if json["url"] != nil{
            url = json["url"] as! String
        }else{
            url = ""
        }
        if json["lastUpdate"] != nil {
            if let lud = json["lastUpdate"] as? Double{
                lastUpdate = lud
            }
        }
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["name"] = name
        json["phone"] = phone
        json["url"] = url
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
}








