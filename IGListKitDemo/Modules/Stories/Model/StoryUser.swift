//
//  StoryUser.swift
//  IGListKitDemo
//
//  Created by Kedar Sukerkar on 15/05/23.
//

import Foundation

public struct StoryUser: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var name: String
    public var image: String
    
    public init(id: String = UUID().uuidString, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
