//
//  HomeTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var view_count: UILabel!
    @IBOutlet weak var motherView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var video:VideoModel?{
        didSet{
            self.configureCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        self.contentImageView.sd_setImageWithURL(NSURL(string: (video?.video_image)!))
        self.avatarImageView.sd_setImageWithURL(NSURL(string: (video?.creator?.profile_image)!))
        self.usernameLabel.text = video?.creator?.name
        self.titleLabel.text = video?.post_title
        if let count = video?.view_count {
            self.view_count.text = String(count)
        }
        
        Utils.makeCircleFromRetacgleView(self.avatarImageView, radius: 14)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
