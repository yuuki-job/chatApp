//
//  MessageCell.swift
//  ChatApp
//
//  Created by 徳永勇希 on 2021/03/09.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    override func layoutSubviews() {
        leftImageView.layer.cornerRadius = leftImageView.bounds.width/2
        rightImageView.layer.cornerRadius = leftImageView.bounds.width/2
        backView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
