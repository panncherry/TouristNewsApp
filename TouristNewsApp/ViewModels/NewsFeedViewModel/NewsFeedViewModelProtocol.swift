//
//  NewsFeedViewModelProtocol.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import RealmSwift

protocol NewsFeedViewModelProtocol {
    
    static var newsFeedList: NewsFeedList? { get }

    static var newsFeedPageInfo: NewsFeedPageInfo? { get }
    
    func fetchNewsFeedData(for page: Int, completion: @escaping (Result<[NewsFeedData], Error>)-> ())
}
