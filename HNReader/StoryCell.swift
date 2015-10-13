//
//  StoryCell.swift
//  HNReader
//
//  Created by Javi Manzano on 13/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation
import UIKit

class StoryCell: UITableViewCell {
    
    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}