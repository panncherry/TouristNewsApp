//
//  MultiMedia.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import RealmSwift

class MultiMedia: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var title: String? = ""
    @Persisted var name: String? = ""
    @Persisted var mediaDescription: String? = ""
    @Persisted var url: String? = ""
    @Persisted var createAt: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, url
        case mediaDescription = "description"
        case createAt = "createat"
    }
}
