//
//  ModelFirebase.swift
//  Class6Demo
//
//  Created by Studio on 05/12/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import Foundation


import Firebase
import FirebaseDatabase

class ModelFirebase {
    var ref: DatabaseReference!
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
    }
    
    // ---- POSTS ----
    
    func addNewPost(post:Post){
        ref.child("posts").child(post.id).setValue(post.toJson())
    }
    
    // ---- STUDENTS ----
    
    func getAllStudentsAndObserve(from:Double, callback:@escaping ([Student])->Void){
        let stRef = ref.child("students")
        let fbQuery = stRef.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Student]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Student(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    func getAllStudents(callback:@escaping ([Student])->Void){
//        ref.child("students").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            var data = [Student]()
//            let value = snapshot.value as! [String:Any]
//            for (_, json) in value{
//                data.append(Student(json: json as! [String : Any]))
//            }
//            callback(data)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        ref.child("students").observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Student]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Student(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewStudent(student:Student){
        ref.child("students").child(student.id).setValue(student.toJson())
    }
    
    func getStudent(byId:String)->Student?{
        return nil
    }

    lazy var storageRef = Storage.storage().reference(forURL:
        "gs://ios-project-9f8b7.appspot.com")
        
    func saveImage(image:UIImage, name:(String),
                             callback:@escaping (String?)->Void){
        let data = UIImageJPEGRepresentation(image,0.8)
        let imageRef = storageRef.child(name)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }

    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    
    //Auth
    
    func signin(email:String, password:String, callback:@escaping (Bool)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (user != nil){
                //user?.user.uid
                callback(true)
            }else{
                callback(false)
            }
        }
        
    }
    
    func createUser(email:String, password:String, callback:@escaping (Bool)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if authResult?.user != nil {
                callback (true)
            }else{
                callback (false)
            }
        }
    }
    
    func checkIfSignIn() -> Bool {
        return (Auth.auth().currentUser != nil)
    }
    
    func getUserId()->String{
        return Auth.auth().currentUser!.uid
    }
    
    
}










