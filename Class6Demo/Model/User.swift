//
//  User.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 09/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import Foundation
import Firebase;

class User {
    let id:String
    let name:String
    let image:String
    let about:String
    var lastUpdate:Double?
    
    init(_id:String, _name:String, _about:String = "", _image:String = "", _lastUpdate:Double? = nil){
        id = _id
        name = _name
        image = _image
        about = _about
        lastUpdate = _lastUpdate
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        name = json["name"] as! String
        about = json["about"] as! String

        if json["image"] != nil{
            image = json["image"] as! String
        }else{
            image = ""
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
        json["about"] = about
        json["image"] = image
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
}
