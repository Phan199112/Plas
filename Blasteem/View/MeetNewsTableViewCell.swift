//
//  MeetNewsTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/30/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class MeetNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentImageview: UIImageView!
    
    
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
        if let videoimage = video?.video_image {
            self.contentImageview.sd_setImageWithURL(NSURL(string: videoimage))
        }
        
        self.titleLabel.text = video?.post_title?.uppercaseString
        if let post_date =  video?.post_date
        {
//            let localIdentifier = "it_IT"
//            let locale = NSLocale(localeIdentifier: localIdentifier)
//            let dateformatter = NSDateFormatter()
//            dateformatter.locale = locale
//            dateformatter.dateFormat = "dd MMMM yyyy"
//            if let date = NSDate(fromString: post_date, withFormat: "yyyy-MM-dd HH:mm:ss") {
//                let local_date = dateformatter.stringFromDate(date)
//                self.dateLabel.text = local_date
//            }
            self.dateLabel.text = post_date
        }
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
