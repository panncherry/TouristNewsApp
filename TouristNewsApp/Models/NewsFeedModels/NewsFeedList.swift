//
//  NewsFeedList.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/21/23.
//

import RealmSwift

class NewsFeedList: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = "USER_ID"
    @Persisted var data: List<NewsFeedData> = List<NewsFeedData>()
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
