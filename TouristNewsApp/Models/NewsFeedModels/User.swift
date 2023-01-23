//
//  User.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import RealmSwift

/// User model
class User: Object, Decodable {
    @Persisted(primaryKey: true) var userid: Int = 0
    @Persisted var name: String = ""
    @Persisted var profilePictureURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case userid, name
        case profilePictureURL = "profilepicture"
        
    }
}
