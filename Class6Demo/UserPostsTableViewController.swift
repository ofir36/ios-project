//
//  UserPostsTableViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 10/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class UserPostsTableViewController: UITableViewController {

    var data = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = Model.instance.getAllPosts(byUserId: Model.instance.getUserId())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! UserPostTableViewCell
        
        let post = data[indexPath.row]
        cell.postTextLabel.text = post.text
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.short
        cell.postDateLabel.text = formatter.string(from: post.date)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "editPostSegue")
        {
            let vc = segue.destination as! NewPostViewController;
            let selectedCell = sender as! UserPostTableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
            let selectedPost = data[indexPath!.row]
            vc.post = selectedPost
            
        }
    }
    

}
