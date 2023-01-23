//
//  NewsFeedPageInfo.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import RealmSwift

/// NewsFeedPageInfo model
class NewsFeedPageInfo: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = "USER_ID"
    @Persisted var perPage: Int = 0
    @Persisted var totalRecord: Int = 0
    @Persisted var totalPages: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case totalPages = "total_pages"
        case totalRecord = "totalrecord"
    }
}
