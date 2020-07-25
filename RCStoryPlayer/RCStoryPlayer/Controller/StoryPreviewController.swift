//
//  StoryPreviewController.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

class StoryPreviewController: UIViewController,ReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(StoryPreviewCell.nib, forCellWithReuseIdentifier: StoryPreviewCell.reuseIdentifier)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView.collectionViewLayout = flowLayout
    }

}

extension StoryPreviewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryPreviewCell.reuseIdentifier, for: indexPath) as? StoryPreviewCell else {
            return UICollectionViewCell()
        }
        cell.containerView.backgroundColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),
                                                     green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                                                     blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
                                                     alpha: 1.0)
        return cell
    }
}

extension StoryPreviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}

