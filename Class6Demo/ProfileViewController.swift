//
//  ProfileViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 09/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
