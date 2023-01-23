//
//  TouristsViewModelProtocol.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//


import RealmSwift

protocol TouristsViewModelProtocol {
    
    static var touristsList: Tourists? { get }

    static var touristsPageInfo: TouristPageInfo? { get }
    
    func fetchTouristsData(for page: Int, completion: @escaping (Result<[TouristData], Error>)-> ())
}
