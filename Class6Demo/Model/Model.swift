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
    static let studentsListNotification = MyNotification<[Student]>("com.menachi.studentlist")
    static let postsListNotification = MyNotification<[Post]>("com.cs.postsList")
    
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
            
            //4. update the local students last update date
            Post.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
            
            //5. get the full data
            let stFullData = Post.getAll(database: self.modelSql.database)
            
            //6. notify observers with full data
            ModelNotification.postsListNotification.notify(data: stFullData)
        }
    }
    
    
    // --- STUDENTS ----
    
    func getAllStudents(){
        //1. read local students last update date
        var lastUpdated = Student.getLastUpdateDate(database: modelSql.database)
        lastUpdated += 1;
        
        //2. get updates from firebase and observe
        modelFirebase.getAllStudentsAndObserve(from:lastUpdated){ (data:[Student]) in
            //3. write new records to the local DB
            for st in data{
                Student.addNew(database: self.modelSql.database, student: st)
                if (st.lastUpdate != nil && st.lastUpdate! > lastUpdated){
                    lastUpdated = st.lastUpdate!
                }
            }
            
            //4. update the local students last update date
            Student.setLastUpdateDate(database: self.modelSql.database, date: lastUpdated)
            
            //5. get the full data
            let stFullData = Student.getAll(database: self.modelSql.database)
            
            //6. notify observers with full data
            ModelNotification.studentsListNotification.notify(data: stFullData)
        }
        
    }
    
    func addNewStudent(student:Student){
        modelFirebase.addNewStudent(student: student);
        //Student.addNew(database: modelSql!.database, student: student)
    }
    
    func getStudent(byId:String)->Student?{
        return modelFirebase.getStudent(byId:byId)
        //return Student.get(database: modelSql!.database, byId: byId);
    }
    
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
    
    func createUser(email:String, password:String, callback:@escaping (Bool)->Void) {
        modelFirebase.createUser(email: email, password: password, callback: callback)
    }
}
