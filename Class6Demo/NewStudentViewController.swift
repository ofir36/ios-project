//
//  NewStudentViewController.swift
//  Class6Demo
//
//  Created by Studio on 21/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import UIKit

class NewStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var image:UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idTextBox: UITextField!
    @IBOutlet weak var nameTextBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takeImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self //as!  & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func save(_ sender: UIButton) {
        if image != nil {
            Model.instance.saveImage(image: image!, name: nameTextBox.text!){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                }
                self.saveStudentInfo(url: _url)
            }
        }else{
            self.saveStudentInfo(url: "")
        }
    }
    
    func saveStudentInfo(url:String)  {
        let st = Student(_id: idTextBox.text!, _name: nameTextBox.text!, _phone:"9999", _url:url)
        Model.instance.addNewStudent(student: st)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
