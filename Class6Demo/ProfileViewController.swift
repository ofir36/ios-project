//
//  ProfileViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 09/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user:User?;
    
    @IBOutlet weak var nameInput: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var aboutInput: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Model.instance.getUserDetails(userId: Model.instance.getUserId()){
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
        
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
