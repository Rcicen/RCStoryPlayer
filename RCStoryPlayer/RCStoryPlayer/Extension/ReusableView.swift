//
//  ReusableView.swift
//  StoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

/// Can be used in views which are initilized with a nib or CollectionView & TableView cells
protocol ReusableView:class {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
