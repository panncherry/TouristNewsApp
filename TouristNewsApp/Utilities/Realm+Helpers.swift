//
//  Realm+Helpers.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//
import Foundation
import RealmSwift

/// Return array of values
extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}

/// Return array of values
extension RealmSwift.List {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
