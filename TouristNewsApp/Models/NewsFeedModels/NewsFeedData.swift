//
//  NewsFeedData.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import RealmSwift

/// NewsFeed model
class NewsFeedData: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int? = 0
    @Persisted var title: String? = ""
    @Persisted var newsFeedDescription: String? = ""
    @Persisted var location: String? = ""
    @Persisted var createdAt: String? = ""
    @Persisted var commentCount: Int? = 0
    @Persisted var user: User?
    @Persisted var multiMedia: List<MultiMedia> = List<MultiMedia>()
    
    enum CodingKeys: String, CodingKey {
        case id, title, location, commentCount
        case newsFeedDescription = "description"
        case createdAt = "createdat"
        case user, multiMedia
    }
}
