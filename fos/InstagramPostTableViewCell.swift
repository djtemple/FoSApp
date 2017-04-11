//
//  InstagramPostTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-03-18.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class InstagramPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var instagramLogoImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        instagramLogoImage.image = UIImage(named: "Instagram_2016_icon copy")
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
