//
//  RegisterViewController.swift
//  iShare
//
//  Created by Ofir Zamir on 08/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var vPasswordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegister(_ sender: Any) {
        if (nameInput.text?.isEmpty ?? true || emailInput.text?.isEmpty ?? true || passwordInput.text?.isEmpty ?? true || vPasswordInput.text?.isEmpty ?? true)
        {
            Utility.showAlert("Please fill all the details", self)
        }
        else if (passwordInput.text != vPasswordInput.text)
        {
            Utility.showAlert("Passwords do not match", self)
        }
        else {
            Utility.showSpinner(onView: self.view)
            
            Model.instance.createUser(email: emailInput.text!, password: passwordInput.text!, name: nameInput.text!)
            { (result : Bool) in
                Utility.removeSpinner()
                if (!result)
                {
                    Utility.showAlert("Error in register, Please try again", self)
                }
                else
                {
                    self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                }
            }
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
