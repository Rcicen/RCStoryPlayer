//
//  StoryPreviewCell.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

let storyContentViewTagIdentifier = 300
let cellContentViewTagIdentifier = 400

protocol StoryPreviewCellDelegate:class {
    func goToPreviousStoryGroup()
    func goToNextStoryGroup()
}

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
    
    var longPressGestureState:UILongPressGestureRecognizer.State?
    
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
            guard let uuid = storyGroup?.uuid else { return }
            contentView.tag = uuid + cellContentViewTagIdentifier
            
        }
    }
    
    var storyIndex:Int = 0 {
        didSet {
            storyIndexDidChanged()
        }
    }
    
    weak var delegate:StoryPreviewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        scrollView.delegate = self
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.addGestureRecognizer(longPressGesture)
        installStoryHeaderViewConstraints()
    }
    
    func installStoryHeaderViewConstraints() {
        addSubview(storyHeaderView)
        NSLayoutConstraint.activate([
            storyHeaderView.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor,constant:10),
            storyHeaderView.leftAnchor.constraint(equalTo:leftAnchor),
            storyHeaderView.rightAnchor.constraint(equalTo:rightAnchor),
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
    
    func changeStoryIndex(to index:Int) {
        guard let storyCount = storyGroup?.storyCount else { return }
        if index >= 0 && index < storyCount {
            let contentOffSet = CGPoint(x: scrollView.frame.width * CGFloat(index), y: 0)
            scrollView.setContentOffset(contentOffSet, animated: false)
            storyGroup?.lastPlayedStoryIndex = index
            storyIndex = index
        } else if index >= storyCount {
            delegate?.goToNextStoryGroup()
        } else if index < 0 {
            delegate?.goToPreviousStoryGroup()
        }
    }
    
    func storyIndexDidChanged() {
        if storyIndex < storyGroup?.storyCount ?? 0 {
            if let story = storyGroup?.stories[storyIndex] {
                if story.kind == .image {
                    if let currentPhotoView = self.currentPhotoView {
                        currentPhotoView.image(withUrl: story.url) { [weak self] (isSuccess) in
                            guard let strongSelf = self else { return }
                            if isSuccess {
                                strongSelf.startProgressBar(for: .image)
                            }else {
                                //TODO:Handle nil image
                            }
                        }
                    }else {
                        let newPhotoView = addNewPhotoView()
                        newPhotoView.image(withUrl: story.url) { [weak self] (isSuccess) in
                            guard let strongSelf = self else { return }
                            if isSuccess {
                                strongSelf.startProgressBar(for: .image)
                            }else {
                                
                            }
                        }
                    }
                } else if story.kind == .video {
                    //TODO: In case of video support
                }
            }
        }
    }
    
    //MARK: - PROGRESSBAR FUNCTIONS
    
    /// Returns the progressBar at given storyIndex if exists
    func getProgressBar(at index:Int) -> IGSnapProgressView? {
        let progressStackView = storyHeaderView.progressStackView
        guard progressStackView.arrangedSubviews.count > 0 else {
            return nil
        }
        let progressBackgroundView = progressStackView.arrangedSubviews.filter({$0.tag == index + progressBarBackgroundViewTagIdentifier }).first
        let progressBar = progressBackgroundView?.subviews.first as? IGSnapProgressView
        progressBar?.story = storyGroup
        return progressBar
    }
    
    func startProgressBar(for kind:MediaContentType) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if kind == .image && strongSelf.currentPhotoView?.image != nil {
                guard let progressBar = strongSelf.getProgressBar(at: strongSelf.storyIndex), let holderView = progressBar.superview  else { return }
                progressBar.snapIndex = strongSelf.storyIndex
                progressBar.start(with: 5.0, holderView: holderView, completion: { [weak self] (storyIndex, isCancelledAbruptly) in
                    guard let strongSelf = self else { return }
                    if isCancelledAbruptly == false {
                        strongSelf.changeStoryIndex(to:strongSelf.storyIndex + 1)
                    }
                })
            } else if kind == .video {
                //TODO:
            }
        }
    }
    
    func stopProgressBar(at index:Int) {
        let progressBar = getProgressBar(at: index)
        progressBar?.updateWithConstraint(as: .Empty)
        progressBar?.stop()
    }
    
    func pauseProgressBar(at index:Int? = nil) {
        if let index = index {
            getProgressBar(at: index)?.pause()
        }
        else {
            guard let lastPlayedIndex = storyGroup?.lastPlayedStoryIndex else { return }
            getProgressBar(at: lastPlayedIndex)?.pause()
        }
    }
    
    func fillProgressBar(at index:Int) {
        let progressBar = getProgressBar(at: index)
        progressBar?.updateWithConstraint(as: .Full)
    }
    
    func fillProgressBar(until index:Int) {
        guard index > 0 else { return }
        for i in 0..<index {
            fillProgressBar(at: i)
        }
    }
    
    func goToPreviousStory() {
        stopProgressBar(at: storyIndex)
        let previousStoryIndex = storyIndex - 1
        let preProgressBar = getProgressBar(at: previousStoryIndex)
        preProgressBar?.reset()
        changeStoryIndex(to: previousStoryIndex)
    }
    
    func goToNextStory() {
        stopProgressBar(at: storyIndex)
        fillProgressBar(at: storyIndex)
        changeStoryIndex(to: storyIndex + 1)
    }
    
    /// PreparesCell on cell willDisplay
    func prepareCell(lastIndex:Int) {
        storyHeaderView.clearProgressBars()
        storyHeaderView.configureProgressBar()
        fillProgressBar(until: lastIndex)
        storyIndex = lastIndex
    }
    
    //MARK: - GESTURE RECOGNIZER ACTIONS
    
    @objc func didTapScreen(_ sender: UITapGestureRecognizer) {
        guard let storyCount = storyGroup?.storyCount else {
            return
        }
        let touchLocation = sender.location(ofTouch: 0, in: scrollView)
        if touchLocation.x > scrollView.contentOffset.x + (scrollView.frame.width/2) {
            goToNextStory()
        } else {
            goToPreviousStory()
        }
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        //TODO: Configure
        longPressGestureState = sender.state
        if sender.state == .began ||  sender.state == .ended {
            if(sender.state == .began) {
                getProgressBar(at: storyIndex)?.pause()
            } else {
                getProgressBar(at: storyIndex)?.resume()
            }
        }
    }
    
    //MARK: - NOTIFICATION CENTER FUNCTIONS
    
    @objc func didEnterBackground() {
        stopProgressBar(at: storyIndex)
    }
    
    @objc func willEnterForeground() {
        startProgressBar(for: .image)
    }
}



extension StoryPreviewCell:UIScrollViewDelegate {
    //TODO: Configure
}

extension StoryPreviewCell:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer is UISwipeGestureRecognizer) {
            return true
        }
        return false
    }
}
