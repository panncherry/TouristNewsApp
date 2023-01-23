//
//  Tourists.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//
import RealmSwift

/// Data model
class Tourists: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int? = 0
    @Persisted var data: List<TouristData> = List<TouristData>()
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
