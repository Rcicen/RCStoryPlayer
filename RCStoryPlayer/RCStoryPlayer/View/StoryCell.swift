//
//  StoryCell.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

class StoryCell:UICollectionViewCell,ReusableView {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
        profileImageView.layer.borderColor = UIColor.red.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.clipsToBounds = true
        nameLabel.textAlignment = .center
        nameLabel.text = "Hello"
    }
}
