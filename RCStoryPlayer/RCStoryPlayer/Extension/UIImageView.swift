//
//  UIImageView.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 28.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import UIKit

extension UIImageView {
    func image(withUrl string: String, completion:@escaping ((Bool)->()) ) {
        self.image = nil
        if let url = URL(string: string) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Failed to load images from url: \(String(describing: error))")
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                            completion(true)
                        }
                    }
                }
            }).resume()
        } else {
            completion(false)
        }
    }
}
