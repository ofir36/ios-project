//
//  StudentsTableViewController.swift
//  Class6Demo
//
//  Created by Studio on 21/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    var data = [Student]()
    var studentListener:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentListener = ModelNotification.studentsListNotification.observe(){
            (data:Any) in
            self.data = data as! [Student]
            self.tableView.reloadData()
        }
       
        Model.instance.getAllStudents()
        
//        Model.instance.signin(email: "eliav@temp.com", password: "1234567890") { (ret:Bool) in
//            if (ret){
//                print("create user success")
//            }else{
//                print("create user fail")
//
//            }
//        }
    }

    deinit{
        if studentListener != nil{
            ModelNotification.studentsListNotification.remove(observer: studentListener!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentTableViewCell
        
        let st = data[indexPath.row]
        cell.nameLabel.text = st.name
        cell.idLabel.text = st.id
        cell.imageView?.image = UIImage(named: "avatar")
        cell.imageView!.tag = indexPath.row
        if st.url != "" {
            Model.instance.getImage(url: st.url) { (image:UIImage?) in
                if (cell.imageView!.tag == indexPath.row){
                    if image != nil {
                        cell.imageView?.image = image!
                    }
                }
            }
        }
        return cell
    }
    
    var selectedId:String?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("user select row \(indexPath.row)")
        selectedId = data[indexPath.row].id
        self.performSegue(withIdentifier: "StudentDetailsView", sender: self)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentDetailsView"{
            let studentDetailsVc:StudentDetailsViewController = segue.destination as! StudentDetailsViewController
            studentDetailsVc.studentId = self.selectedId
            
        }
        
    }
    
    
}
