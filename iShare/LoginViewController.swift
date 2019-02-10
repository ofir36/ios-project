//
//  LoginViewController.swift
//  iShare
//
//  Created by Ofir Zamir on 08/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    @IBAction func onLogin(_ sender: Any) {
        if (emailInput.text?.isEmpty ?? true || passwordInput.text?.isEmpty ?? true)
        {
            Utility.showAlert("Please fill all the details", self)
        }
        else
        {
            Utility.showSpinner(onView: self.view)
            
            Model.instance.signin(email: emailInput.text!, password: passwordInput.text!)
            {(result:Bool) in
                Utility.removeSpinner()
                if (!result)
                {
                     Utility.showAlert("Error in login, please check your details", self)
                }
                else {
                    self.performSegue(withIdentifier: "segueToMain", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (Model.instance.checkIfSignedIn())
        {
            self.performSegue(withIdentifier: "segueToMain", sender: self)
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
