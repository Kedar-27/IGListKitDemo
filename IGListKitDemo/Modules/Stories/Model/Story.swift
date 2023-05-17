//
//  Story.swift
//  IGListKitDemo
//
//  Created by Ked-27 on 15/05/23.
//

import Foundation


public struct Story: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var mediaURL: String
    public var date: String
    public var type: StoryUIMediaType
    public var isReady: Bool = false
    public var duration: Double = Constant.storySecond
    
    public init(id: String = UUID().uuidString, mediaURL: String, date: String, type: StoryUIMediaType, isReady: Bool = false, duration: Double = 5) {
        self.id = id
        self.mediaURL = mediaURL
        self.date = date
        self.type = type
        self.isReady = isReady
        self.duration = duration
        Constant.storySecond = duration
    }
}

    

