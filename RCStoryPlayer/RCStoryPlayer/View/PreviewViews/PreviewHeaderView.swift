//
//  PreviewHeaderView.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

public let progressBarBackgroundViewTagIdentifier = 100
public let progressBarViewTagIdentifier = 200


class PreviewHeaderView:UIView {
    
    var progressStackView:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    /// Holds following views [imageView,userNameLabel,timeLabel]
    var detailStackView:UIStackView?
    
    /// Displays story poster's profile picture
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profile_placeholder")
        return imageView
    }()
    
    /// Displays story poster's username
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "TestUser"
        return label
    }()
    
    /// Displays the time passed since story posted
    let timeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "12m"
        return label
    }()
    
    let closeButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    var storyGroup:StoryGroup? {
        didSet {
            configureUI()
        }
    }
    
    func configureUI() {
        addSubview(closeButton)
        configureProgressStackViewConstraints()
        configureProgressBar()
        installDetailStackView()
        configureDetailViewConstraints()
    }
    
    /// Configures progressBars & loads them to progressStackView.
    func configureProgressBar() {
        guard let storyCount = storyGroup?.storyCount, progressStackView.arrangedSubviews.count == 0 else {
            return
        }
        let height:CGFloat = 3
        var progressBarBackgroundViews = [UIView]()
        var progressBarViews = [IGSnapProgressView]()
        
        // Creates the progressBar & its backgroundView
        for i in 0..<storyCount {
            let backgroundView = UIView()
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.layer.cornerRadius = 1
            backgroundView.layer.masksToBounds = true
            backgroundView.backgroundColor = .lightGray
            backgroundView.tag = i + progressBarBackgroundViewTagIdentifier
            progressBarBackgroundViews.append(backgroundView)
            backgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
            
            let progressView = IGSnapProgressView()
            progressView.layer.cornerRadius = 1
            progressView.layer.masksToBounds = true
            progressView.backgroundColor = .white
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.tag = i + progressBarViewTagIdentifier
            progressView.heightAnchor.constraint(equalToConstant: height).isActive = true
            progressBarViews.append(progressView)
            
            backgroundView.addSubview(progressView)
            progressStackView.addArrangedSubview(backgroundView)
        }
    }
    
    /// Adds progressStack on view & configures its constraints
    func configureProgressStackViewConstraints() {
        addSubview(progressStackView)
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            progressStackView.topAnchor.constraint(equalTo: self.topAnchor),
            progressStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            progressStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            progressStackView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func installDetailStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageView,userNameLabel,timeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        detailStackView = stackView
        addSubview(detailStackView!)
    }
    
    func configureDetailViewConstraints() {
        guard let detailStackView = detailStackView else { return }
        let edgeMargin:CGFloat = 15
        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(equalTo: self.progressStackView.bottomAnchor, constant: 10),
            detailStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeMargin),
            
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            closeButton.centerYAnchor.constraint(equalTo: detailStackView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeMargin),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func clearProgressBars() {
        progressStackView.arrangedSubviews.forEach{
            ($0.subviews.first as! IGSnapProgressView).stop()
            $0.removeFromSuperview()
        }
    }
    
    @objc func didTapClose() {
        NotificationCenter.default.post(name: .dismissPreviewController, object: nil)
    }
}

