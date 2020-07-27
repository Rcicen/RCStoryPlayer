//
//  IGSnapProgressView.swift
//  InstagramStories
//
//  Created by Ranjith Kumar on 9/15/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import UIKit

enum ProgressorState {
    case notStarted
    case paused
    case running
    case finished
}

final class IGSnapProgressView: UIView, ViewAnimator {

    enum progressBarFillStatus {
        case Empty
        case Full
    }

    /// This represents the current story index of a storyGroup
    public var snapIndex: Int?
    public var story: StoryGroup!
    public var widthConstraint: NSLayoutConstraint?
    public var state: ProgressorState = .notStarted
}

extension IGSnapProgressView {
    func updateWithConstraint(as status:progressBarFillStatus) {
        widthConstraint?.isActive = false
        if status == .Empty {
            widthConstraint?.constant = 0
        } else {
            guard let backgroundView = superview else { return }
            widthConstraint = self.widthAnchor.constraint(equalTo: backgroundView.widthAnchor)
        }
        widthConstraint?.isActive = true
    }
}
