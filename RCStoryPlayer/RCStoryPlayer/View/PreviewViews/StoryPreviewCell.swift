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
        recognizer.minimumPressDuration = 0.3
        recognizer.delegate = self
        return recognizer
    }()
    
    
    //MARK: UIGestureRecognizer Actions
    @objc func didTapScreen(_ sender: UITapGestureRecognizer) {
        //TODO: Configure
        let touchLocation = sender.location(ofTouch: 0, in: scrollView)
        
        if touchLocation.x < scrollView.contentOffset.x + (scrollView.frame.width/2) {
            //TODO: Go to previous story or previous userStory (Goes to last displayed story index of that user)
        } else {
            //TODO: Go to next story or next userStory (Goes to last displayed story index of that user)
        }
        
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        //TODO: Configure
        if sender.state == .began ||  sender.state == .ended {
            if(sender.state == .began) {
                //TODO: Pause story
            } else {
                //TODO: Resume story
            }
        }
    }
}



extension StoryPreviewCell:UIScrollViewDelegate {
    //TODO: Configure
}

extension StoryPreviewCell:UIGestureRecognizerDelegate {
    // TODO: Simultanious recognition
}
