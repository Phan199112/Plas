//
//  NotificationTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/30/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarimageView: UIImageView!
    
    var homeVC:NotificationTableViewController?
    var notification:VideoModel?{
        didSet{
            self.configureView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureView() {
        self.titleLabel.text = notification?.post_title
        self.nameLabel.text = notification?.creator?.name
        Utils.makeCircleFromRetacgleView(self.avatarimageView, radius: 20)
        if let profile_image = notification?.creator?.profile_image
        {
            self.avatarimageView.sd_setImageWithURL(NSURL(string: profile_image))
        }else{
            self.avatarimageView.image = UIImage(named: "default")
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onVideoDetailView(sender: AnyObject) {
        
    }
}
