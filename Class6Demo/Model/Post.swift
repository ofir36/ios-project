//
//  Post.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 04/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import Foundation
import Firebase;

class Post {
    let id:String
    let text:String
//    var date:Double?
    let userId:String
    let image:String
    var lastUpdate:Double?
    
    init(_id:String, _text:String, _userId:String, _image:String = ""){
        id = _id
        text = _text
        userId = _userId
        image = _image
//        date = _date
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        text = json["name"] as! String
//        date = json["date"] as? Double
        userId = json["userId"] as! String
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
        json["text"] = text
//        json["date"] = date
        json["userId"] = userId
        json["image"] = image
        json["lastUpdate"] = ServerValue.timestamp()
        return json
    }
}
