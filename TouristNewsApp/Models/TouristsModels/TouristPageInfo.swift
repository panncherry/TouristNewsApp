//
//  TouristPageInfo.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/22/23.
//

import Foundation
import RealmSwift

class TouristPageInfo: Object, Decodable {
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
