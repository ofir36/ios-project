//
//  ProfileViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 09/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var userListener:NSObjectProtocol?
    var user:User?;
    
    @IBOutlet weak var nameInput: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var aboutInput: UILabel!
    
    @IBOutlet weak var userPostsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListener = ModelNotification.userNotification.observe(){
            (user:User) in
            self.user = user;
            
            self.nameInput.text = user.name;
            self.aboutInput.text = user.about
            
            if(user.image != "")
            {
                Model.instance.getImage(url: user.image){
                    (image:UIImage?) in
                    self.profileImageView.image = image
                }
            }
        }
        
        Model.instance.getUserDetails();
        
        // Initialize user posts view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cvc: UserPostsTableViewController = storyboard.instantiateViewController(withIdentifier: "UserPostsViewController") as! UserPostsTableViewController
        self.addChildViewController(cvc)
        cvc.view.frame = self.userPostsView.frame
        cvc.view.frame.origin = CGPoint.zero
        self.userPostsView.addSubview(cvc.view)
    }
    
    deinit{
        if userListener != nil{
            ModelNotification.userNotification.remove(observer: userListener!)
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let result = Model.instance.logout()
        
        if (!result)
        {
            Utility.showAlert("Error logging out, please try again", self)
        }
        else {
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editProfileSegue")
        {
            let editProfieVC = segue.destination as! EditProfileViewController
            editProfieVC.user = self.user
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
