//
//  EditProfileViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 09/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: User?
    var image:UIImage?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var aboutInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (user != nil)
        {
            self.nameInput.text = user!.name;
            self.aboutInput.text = user!.about
            if (user!.image != "")
            {
                Model.instance.getImage(url: user!.image){
                    (image:UIImage?) in
                    self.profileImageView.image = image
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        if (nameInput.text?.isEmpty ?? true)
        {
            Utility.showAlert("Name can't be empty", self)
        }
        else {
            Utility.showSpinner(onView: self.view)
            if image != nil {
                Model.instance.saveImage(image: image!, name: UUID().uuidString){ (url:String?) in
                    var _url = ""
                    if url != nil {
                        _url = url!
                    }
                    self.editDetails(url: _url)
                }
            }else{
                self.editDetails(url: user!.image)
            }
        }
    }
    
    func editDetails(url:String)  {
        let user = User(_id: Model.instance.getUserId(), _name: nameInput.text!, _about:aboutInput.text!, _image: url)
        Model.instance.updateUser(user: user)
        self.navigationController?.popViewController(animated: true)
        Utility.removeSpinner()
    }
    
    @IBAction func onChoosePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType =
            UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        profileImageView.image = image
        self.dismiss(animated: true, completion: nil)
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
