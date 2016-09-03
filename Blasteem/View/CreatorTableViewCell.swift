//
//  CreatorTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/23/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CreatorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //Model
    var creator:CreatorModel?{
        didSet{
            self.configureView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureView() {
        if let profile_url = creator?.profile_image {
            avatarImageView.sd_setImageWithURL(NSURL(string: profile_url))
        }else{
            avatarImageView.image = UIImage(named: "default")
        }
        Utils.makeCircleFromRetacgleView(avatarImageView, radius: 16)
        nameLabel.text = creator?.name
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
