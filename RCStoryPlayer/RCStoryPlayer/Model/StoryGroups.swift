//
//  StoryGroups.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 26.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import Foundation

class StoryGroups:Codable {
    let storyGroups:[StoryGroup]
    let count:Int
    
    enum CodingKeys: String, CodingKey {
        case storyGroups = "story_groups"
        case count = "count"
    }
}

