//
//  HomeModel.swift
//  IGListKitDemo
//
//  Created by Ked-27 on 07/03/23.
//

import Foundation
import IGListKit


final class PostModel: Codable, ListDiffable, Equatable {
        
    
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return (id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? PostModel else { return false }
        return self.id == object.id && self.userID == object.userID
    }

    static func == (lhs: PostModel, rhs: PostModel) -> Bool {
        return lhs.id == rhs.id
    }

}
