//
//  StudentDetailsViewController.swift
//  Class6Demo
//
//  Created by Studio on 21/11/2018.
//  Copyright © 2018 Studio. All rights reserved.
//

import UIKit

class StudentDetailsViewController: UIViewController {

    var studentId:String?
    var student:Student?
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if studentId != nil {
            student = Model.instance.getStudent(byId: studentId!)
            nameLabel.text = student?.name
        }
        // Do any additional setup after loading the view.
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
