//
//  PreviewHeaderView.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

class PreviewHeaderView:UIView {
    
    //TODO: Add progress bar
    
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
    
    var storyGroup:StoryGroup?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
        configureLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadViews() {
        configureProgressBar()
        configureDetailStackView()
        addSubview(closeButton)
    }
    
    func configureProgressBar() {
        //TODO: Configure ProgressBar & add it to subview
    }
    
    func configureDetailStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageView,userNameLabel,timeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        detailStackView = stackView
        addSubview(detailStackView!)
    }
    
    func configureLayoutConstraints() {
        guard let detailStackView = detailStackView else { return }
        let edgeMargin:CGFloat = 15
        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10), // TODO: Top constraint will be refactored as progressbar
            detailStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeMargin),
            
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            closeButton.centerYAnchor.constraint(equalTo: detailStackView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -edgeMargin),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc func didTapClose() {
        NotificationCenter.default.post(name: .dismissPreviewController, object: nil)
    }
}

