//
//  Story.swift
//  RCStoryPlayer
//
//  Created by Radun Cicen on 26.07.2020.
//  Copyright © 2020 raduncicen.com. All rights reserved.
//

import Foundation

enum MediaContentType:String {
    case image
    case video
    case unknown
}

class Story:Codable {
    /// Content url
    let url: String
    
    let storyPublishDate:String
    
    private let contentType:String
    
    var timePassed:String {
        return storyPublishDate //For the sake of simplicity in creating dummy data and displaying reasonable timePassed information, I have decided to set storyPublishDate as string
    }
    
    var kind: MediaContentType {
        if contentType == "image" {
            return .image
        } else if contentType == "video" {
            return .video
        } else {
            return .unknown
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case url
        case storyPublishDate = "story_publish_date"
        case contentType = "media_kind"
        
    }
}
