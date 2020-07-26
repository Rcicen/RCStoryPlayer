//
//  Story.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 26.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import Foundation


class Story:Codable {
    /// Content url
    let url: String
    let storyDate:Date
    let contentType:String
    var kind: MediaContentType
    
    var timePassed:String {
        return "5m" //storyDate.timeIntervalSinceNow
    }
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case storyDate = "story_publish_date"
        case contentType = "media_type"
        case kind = "media_kind"
    }
}
