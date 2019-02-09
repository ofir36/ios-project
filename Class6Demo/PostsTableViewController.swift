//
//  PostsTableViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 06/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    var data = [Post]()
    var postsListener:NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        postsListener = ModelNotification.postsListNotification.observe(){
            (data:Any) in
            self.data = data as! [Post]
            self.tableView.reloadData()
        }
        
        Model.instance.getAllPosts()
    }
    
    deinit{
        if postsListener != nil{
            ModelNotification.postsListNotification.remove(observer: postsListener!)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell

        let post = data[indexPath.row]
        cell.postTextView.text = post.text
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.short
        cell.dateLabel.text = formatter.string(from: post.date)
        
        cell.postImageView?.image = nil
        cell.postImageView!.tag = indexPath.row
        if post.image != "" {
            Model.instance.getImage(url: post.image) { (image:UIImage?) in
                if (cell.postImageView!.tag == indexPath.row){
                    if image != nil {
                        cell.postImageView?.image = image!
                    }
                }
            }
        }
        
        cell.userNameLabel.text = ""
        cell.userImageView.image = UIImage(named: "User")
        cell.userImageView!.tag = indexPath.row
        Model.instance.getUserDetails(byId: post.userId){
            (user:User)in
            cell.userNameLabel.text = user.name;
            if user.image != "" {
                Model.instance.getImage(url: user.image) { (image:UIImage?) in
                    if (cell.userImageView!.tag == indexPath.row){
                        if image != nil {
                            cell.userImageView?.image = image!
                        }
                    }
                }
            }
        }

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
