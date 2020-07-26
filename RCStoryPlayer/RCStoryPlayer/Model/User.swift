//
//  User.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 26.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import Foundation

class User:Codable {
    let name:String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case imageUrl = "image_url"
    }
}
