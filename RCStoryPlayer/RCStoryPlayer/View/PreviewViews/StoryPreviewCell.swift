//
//  StoryPreviewCell.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

let storyContentViewTagIdentifier = 300

class StoryPreviewCell: UICollectionViewCell,ReusableView {
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let storyHeaderView: PreviewHeaderView = {
        let view = PreviewHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Returns the photoView at index
    var currentPhotoView: UIImageView? {
        if let imageView = scrollView.subviews.filter({$0.tag == storyIndex + storyContentViewTagIdentifier}).first as? UIImageView {
            return imageView
        }
        return nil
    }
    
    var storyGroup:StoryGroup? {
        didSet {
            storyHeaderView.storyGroup = storyGroup
        }
    }
    
    var storyIndex:Int = 0 {
        didSet {
            storyIndexChanged()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.addGestureRecognizer(longPressGesture)
        installStoryHeaderViewConstraints()
    }
    
    func installStoryHeaderViewConstraints() {
        addSubview(storyHeaderView)
        NSLayoutConstraint.activate([
            storyHeaderView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            storyHeaderView.leftAnchor.constraint(equalTo: self.leftAnchor),
            storyHeaderView.rightAnchor.constraint(equalTo: self.rightAnchor),
            storyHeaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    /// Creates and constraints a new imageView to scrollView
    func addNewPhotoView() -> UIImageView {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.tag = storyIndex + storyContentViewTagIdentifier
        scrollView.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: storyIndex == 0 ? scrollView.leadingAnchor : scrollView.subviews[storyIndex - 1].trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            photoImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
        ])
        return photoImageView
    }
    
    func storyIndexChanged() {
        if storyIndex < storyGroup?.storyCount ?? 0 {
            if let story = storyGroup?.stories[storyIndex] {
                if story.kind == .image {
                    if let currentPhotoView = self.currentPhotoView {
                        currentPhotoView.ImageWithURL(story.url) { (isSuccess) in
                            if isSuccess {
                                
                            }else {
                                
                            }
                        }
                    }else {
                        let newPhotoView = addNewPhotoView()
                        newPhotoView.ImageWithURL(story.url) { (isSuccess) in
                            if isSuccess {
                                
                            }else {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func changeStoryIndex(to index:Int) {
        guard let storyCount = storyGroup?.storyCount else { return }
        if index >= 0 && index < storyCount {
            let contentOffSet = CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0)
            scrollView.setContentOffset(contentOffSet, animated: false)
            storyGroup?.lastPlayedStoryIndex = index
            storyIndex = index
        } else {
            //TODO: Move to the next StoryGroup ( CollectionView needs to move next index)
        }
    }
    
    
    //MARK: - GESTURE RECOGNIZER ACTIONS
    @objc func didTapScreen(_ sender: UITapGestureRecognizer) {
        //TODO: Configure
        guard let storyCount = storyGroup?.storyCount else {
            return
        }
        
        let touchLocation = sender.location(ofTouch: 0, in: scrollView)
        
        if touchLocation.x > scrollView.contentOffset.x + (scrollView.frame.width/2) {
            //TODO: Go to next story or next userStory (Goes to last displayed story index of that user)
            if storyIndex >= 0 && storyIndex <= storyCount {
                changeStoryIndex(to: storyIndex + 1)
            }
        } else {
            //TODO: Go to previous story or previous userStory (Goes to last displayed story index of that user)
            if storyIndex >= 1 && storyIndex <= storyCount {
                changeStoryIndex(to: storyIndex - 1)
            }
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
