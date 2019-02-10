//
//  UserPostTableViewCell.swift
//  iShare
//
//  Created by Ofir Zamir on 10/02/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
