//
//  TouristData.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import RealmSwift

class TouristData: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int? = 0
    @Persisted var name: String = ""
    @Persisted var email: String = ""
    @Persisted var location: String = ""
    @Persisted var createdAt: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "tourist_name"
        case email = "tourist_email"
        case location = "tourist_location"
        case createdAt = "createdat"
    }
}
