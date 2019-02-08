//
//  NewPostViewController.swift
//  Class6Demo
//
//  Created by Ofir Zamir on 05/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image:UIImage?

    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onChooseImage(_ sender: Any) {
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
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func onShare(_ sender: Any) {
        Utility.showSpinner(onView: self.view)
        if image != nil {
            Model.instance.saveImage(image: image!, name: UUID().uuidString){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                }
                self.sharePost(url: _url)
            }
        }else{
            self.sharePost(url: "")
        }
    }
    
    func sharePost(url:String)  {
        let post = Post(_id: UUID().uuidString, _text: textInput.text, _userId: "111", _image: url)
        Model.instance.addNewPost(post: post)
        print("post saved successfully")
        self.navigationController?.popViewController(animated: true)
        Utility.removeSpinner()
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
