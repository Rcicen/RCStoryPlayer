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
    
    var storyGroups:StoryGroups?
    
    var userSelectedStoryIndex:Int = 0
    
    var currentCellIndex:Int = 0
    
    var visibleCellUuid:Int?
    
    var blockOnce = true
    
    lazy var previewFlowLayout:AnimatedCollectionViewLayout = {
        let flowLayout = AnimatedCollectionViewLayout()
        flowLayout.animator = CubeAttributesAnimator(perspective: -1/100, totalAngle: .pi/15)
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(StoryPreviewCell.nib, forCellWithReuseIdentifier: StoryPreviewCell.reuseIdentifier)
        collectionView.collectionViewLayout = previewFlowLayout
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPreviewController), name: .dismissPreviewController, object: nil)
        scrollToUserSelectedStoryGroup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func scrollToUserSelectedStoryGroup() {
        let indexPath = IndexPath(row: userSelectedStoryIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        self.userSelectedStoryIndex = 0
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
        currentCellIndex = indexPath.row
        cell.delegate = self
        cell.storyGroup = storyGroups?.storyGroups[indexPath.row]
//        cell.storyIndex = 0 //Will be removed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let visibleCells = collectionView.visibleCells.sorted { (cell1, cell2) -> Bool in
            cell1.frame.minX < cell2.frame.minX
        }
        if let visibleCell = visibleCells.first as? StoryPreviewCell {
            self.visibleCellUuid = visibleCell.storyGroup?.uuid
            visibleCell.pauseProgressBar()
        }
        
        guard let cell = cell as? StoryPreviewCell else { return }
        if indexPath.row == currentCellIndex {
            let lastPlayedStoryIndex = storyGroups?.storyGroups[userSelectedStoryIndex + currentCellIndex].lastPlayedStoryIndex ?? (cell.storyGroup?.lastPlayedStoryIndex ?? 0)
            cell.prepareCell(lastIndex: lastPlayedStoryIndex)
            if blockOnce {
                blockOnce = !blockOnce
                return
            }
            cell.pauseProgressBar()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleCells = collectionView.visibleCells.sorted { (cell1, cell2) -> Bool in
            cell1.frame.minX < cell2.frame.minX
        }
        guard let visibleCell = visibleCells.first as? StoryPreviewCell, let visibleIndex = collectionView.indexPath(for: visibleCell)?.row else { return }
//        if visibleCellUuid == visibleCell.storyGroup?.uuid {
            currentCellIndex = visibleIndex
            if visibleCell.longPressGestureState == nil, let lastPlayedStoryIndex = visibleCell.storyGroup?.lastPlayedStoryIndex {
                visibleCell.getProgressBar(at: lastPlayedStoryIndex)?.resume()
//                visibleCell.stopProgressBar(at: lastPlayedStoryIndex)
//                visibleCell.startProgressBar(for: .image)
            }
            visibleCell.longPressGestureState = nil
//        }
//        else {
//            guard let cell = cell as? StoryPreviewCell else { return }
//            cell.startProgressBar(for: .image)
//        }
        
        
    }
    
}

extension StoryPreviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}

extension StoryPreviewController:StoryPreviewCellDelegate {
    func goToPreviousStoryGroup() {
        if currentCellIndex > 0 {
            currentCellIndex -= 1
            let indexPath = IndexPath(row: currentCellIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        
    }
    
    func goToNextStoryGroup() {
        let index = userSelectedStoryIndex + currentCellIndex
        if index < storyGroups?.count ?? 0 {
            currentCellIndex += 1
            let indexPath = IndexPath(row: currentCellIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
}


extension StoryPreviewController:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let visibleCell = collectionView.visibleCells.first as? StoryPreviewCell, let storyGroup = visibleCell.storyGroup else {
            return
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        guard let visibleCell = collectionView.visibleCells.first as? StoryPreviewCell, let storyGroup = visibleCell.storyGroup else {
//            return
//        }
//        visibleCell.getProgressBar(at: storyGroup.lastPlayedStoryIndex)?.resume()
    }

}
