//
//  CommentTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/26/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    var comment_index:Int?
    var comment:CommentModel?
    var homeVC:VideoDetailViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        if comment_index! % 2 != 0 {
            self.contentView.backgroundColor = UIColor.whiteColor()
        }else{
            self.contentView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
        self.replyTextView.text = comment?.comment_content
        self.usernameLabel.text = comment?.comment_author_name
        Utils.makeCircleFromRetacgleView(self.avatarImageView, radius: 14)
        if let profile_picture =  comment?.author_profile_picture{
            self.avatarImageView.sd_setImageWithURL(NSURL(string: profile_picture))
            
        }else{
            self.avatarImageView.image = UIImage(named: "default")
        }
        
    }
    
    @IBAction func onRespond(sender: AnyObject) {
        homeVC!.respondCommentSelected(comment!)
    }
}
