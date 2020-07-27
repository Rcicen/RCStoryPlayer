//
//  ViewController.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 25.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var stories:StoryGroups? {
        didSet {
            collectionView.reloadData()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = MockDataProvider.shared.retrieve(from: "MockData", StoryGroups.self).done({ (storyGroups) in
            self.stories = storyGroups
        }).catch({ (error) in
            print(error)
        })
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.reuseIdentifier, for: indexPath) as? StoryCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = UIColor.blue
        cell.story = stories?.storyGroups[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Present Preview Controller
        let previewController = self.storyboard?.instantiateViewController(withIdentifier: StoryPreviewController.reuseIdentifier) as! StoryPreviewController
        previewController.modalPresentationStyle = .overFullScreen
        previewController.storyGroups = stories
        previewController.userSelectedStoryIndex = indexPath.row
        self.present(previewController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}

