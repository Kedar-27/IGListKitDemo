//
//  StoryUIModel.swift
//  IGListKitDemo
//
//  Created by Ked-27 on 15/05/23.
//

import Foundation

public struct StoryUIModel: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var user: StoryUser
    public var isSeen: Bool = false
    public var stories: [Story]
    
    public init(id: String = UUID().uuidString, user: StoryUser, isSeen: Bool = false, stories: [Story]) {
        self.id = id
        self.user = user
        self.isSeen = isSeen
        self.stories = stories
    }    }
