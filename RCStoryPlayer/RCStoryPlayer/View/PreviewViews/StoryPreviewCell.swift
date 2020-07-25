//
//  StoryPreviewCell.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell,ReusableView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .darkGray
    }

    private lazy var tapGesture:UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen(_:)))
        recognizer.cancelsTouchesInView = false;
        recognizer.numberOfTapsRequired = 1
        recognizer.delegate = self
        return recognizer
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        recognizer.minimumPressDuration = 0.2
        recognizer.delegate = self
        return recognizer
    }()
    
    
    //MARK: UIGestureRecognizer Actions
    @objc func didTapScreen(_ sender: UITapGestureRecognizer) {
        //TODO: Configure
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        //TODO: Configure
    }
}



extension StoryPreviewCell:UIScrollViewDelegate {
    //TODO: Configure
}

extension StoryPreviewCell:UIGestureRecognizerDelegate {
    // TODO: Simultanious recognition
}
