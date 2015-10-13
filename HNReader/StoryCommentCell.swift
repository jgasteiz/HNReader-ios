//
//  StoryCommentCell.swift
//  HNReader
//
//  Created by Javi Manzano on 10/13/15.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation
import UIKit

class StoryCommentCell: UITableViewCell {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indentationWidth = 20.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let indentPoints: CGFloat = CGFloat(self.indentationLevel) * self.indentationWidth
        
        self.contentView.frame = CGRectMake(
            indentPoints,
            self.contentView.frame.origin.y,
            self.contentView.frame.size.width - indentPoints,
            self.contentView.frame.size.height
        )
    }
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}