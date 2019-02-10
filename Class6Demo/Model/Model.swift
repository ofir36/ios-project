//
//  Model.swift
//  Class6Demo
//
//  Created by Studio on 21/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import Foundation
import UIKit


class ModelNotification{
    static let postsListNotification = MyNotification<[Post]>("com.cs.postsList")
    static let userProfileNotification = MyNotification<User>("com.cs.userProfile")
    
    class MyNotification<T>{
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
        
        
    }
    
}


class Model {
    static let instance:Model = Model()
    
    
    var modelSql = ModelSql();
    var modelFirebase = ModelFirebase();
    
    private init(){
        //modelSql = ModelSql()
    }
    
    
    // --- POSTS ----
    
    
    func addNewPost(post:Post){
        modelFirebase.addNewPost(post: post)
        //Student.addNew(database: modelSql!.database, student: student)
    }
    
    func getAllPosts() {
        //1. read local students last update date
        var lastUpdated = Post.getLastUpdateDate(database: modelSql.database)
        lastUpdated += 1;
        
        //2. get updates from firebase and observe
        modelFirebase.getAllPostsAndObserve(from:lastUpdated){ (data:[Post]) in
            //3. write new records to the local DB
            for st in data{
                Post.addNew(database: self.modelSql.database, post: st)
                if (st.lastUpdate != nil && st.lastUpdate! > lastUpdated){
                    lastUpdated = st.lastUpdate!
                }
            }
            
            //4. update the local posts last update date
            Post.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
            
            //5. get the full data
            let stFullData = Post.getAll(database: self.modelSql.database)
            
            //6. notify observers with full data
            ModelNotification.postsListNotification.notify(data: stFullData)
        }
    }
    
    func getAllPosts(byUserId: String)->[Post]{
        return Post.get(database: modelSql.database, byUserId: byUserId)
    }
    
    func deletePost(post:Post)
    {
        modelFirebase.deletePost(post: post)
    }
    
    // ---- USERS ----
    
    func updateUser(user:User)
    {
        modelFirebase.updateUser(user: user)
    }
    
    func getUserDetails(byId:String, callback:@escaping (User)->Void)
    {
        modelFirebase.getUserDetails(userId: byId){
            (user:User) in
            
            User.addNew(database: self.modelSql.database, user: user)
            let fullData = User.get(database: self.modelSql.database, byId: byId)
            callback(fullData!);
        }
    }
    
    func getUserDetails()
    {
        let userId = self.getUserId();
        
        modelFirebase.getUserDetailsAndObserve(userId: userId){ (data:User) in
            
            User.addNew(database: self.modelSql.database, user: data)
            let fullData = User.get(database: self.modelSql.database, byId: userId)
            ModelNotification.userProfileNotification.notify(data: fullData!)
        }
    }
    
    // --- IMAGES ----
    
    func saveImage(image:UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
        
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        //modelFirebase.getImage(url: url, callback: callback)
        
        //1. try to get the image from local store
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            //2. get the image from Firebase
            modelFirebase.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
                print("got image from firebase \(localImageName)")
            }
        }
    }
 
    
    /// File handling
    func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }


    
    ///Authentication
    func signin(email:String, password:String, callback:@escaping (Bool)->Void) {
        modelFirebase.signin(email: email, password: password, callback: callback)
    }
    
    func createUser(email:String, password:String, name:String, callback:@escaping (Bool)->Void) {
        modelFirebase.createUser(email: email, password: password, name: name, callback: callback)
    }
    
    func checkIfSignedIn() -> Bool {
        return modelFirebase.checkIfSignedIn()
    }
    
    func getUserId() -> String {
        return modelFirebase.getUserId()
    }
    
    func logout() -> Bool {
        return modelFirebase.logout()
    }
}
