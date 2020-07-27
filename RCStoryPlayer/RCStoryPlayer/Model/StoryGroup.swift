//
//  StoryGroup.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 26.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import Foundation

class StoryGroup:Codable {
    
    let user:User
    let stories:[Story]
    let uuid:Int
    let storyCount:Int
    var lastPlayedStoryIndex:Int = 0
    var isCancelledAbruptly:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case user
        case stories  
        case uuid = "id"
        case storyCount = "story_count"
    }
}

extension StoryGroup: Equatable {
    public static func == (lhs: StoryGroup, rhs: StoryGroup) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
