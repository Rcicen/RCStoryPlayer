//
//  StoryPreviewController.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class StoryPreviewController: UIViewController,ReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var previewFlowLayout:AnimatedCollectionViewLayout = {
        let flowLayout = AnimatedCollectionViewLayout()
        flowLayout.animator = CubeAttributesAnimator(perspective: -1/100, totalAngle: .pi/15)
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        return flowLayout
    }()
    
    var storyGroups:StoryGroups?
    
    var userSelectedStoryIndex:Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(StoryPreviewCell.nib, forCellWithReuseIdentifier: StoryPreviewCell.reuseIdentifier)
        collectionView.collectionViewLayout = previewFlowLayout
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPreviewController), name: .dismissPreviewController, object: nil)
    }
    
    @objc func dismissPreviewController() {
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: true, completion: nil)
    }
}

extension StoryPreviewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyGroups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryPreviewCell.reuseIdentifier, for: indexPath) as? StoryPreviewCell else {
            return UICollectionViewCell()
        }
        cell.storyGroup = storyGroups?.storyGroups[indexPath.row]
        cell.storyIndex = 0 //Will be removed
        return cell
    }
}

extension StoryPreviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}

