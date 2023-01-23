//
//  NewsFeedViewModel.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit
import RealmSwift

/// NewsFeed ViewModel
class NewsFeedViewModel: NSObject, NewsFeedViewModelProtocol {
    
    static let shared = NewsFeedViewModel()
    
    static var newsFeedList: NewsFeedList?
    
    static var newsFeedPageInfo: NewsFeedPageInfo?
    
    private var isRequestingNewsFeedData: Bool = false
    
    /// Fetch newsFeed data for input page number
    func fetchNewsFeedData(for page: Int, completion: @escaping (Result<[NewsFeedData], Error>)-> ()) {
        guard !isRequestingNewsFeedData else {
            return
        }
        
        isRequestingNewsFeedData = true
        
        guard let url = URL(string: "\(BaseURLs.newsFeedURL)\(page)") else {
            isRequestingNewsFeedData = false
            return
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.isRequestingNewsFeedData = false
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let newsFeedPageInfo = try JSONDecoder().decode(NewsFeedPageInfo.self, from: data)
                    if NewsFeedViewModel.newsFeedPageInfo == nil {
                        DispatchQueue.main.async {
                            RealmDatabaseManager.shared.saveNewsFeedPageInfo(newsFeedPageInfo)
                        }
                    }
                    NewsFeedViewModel.newsFeedPageInfo = newsFeedPageInfo
                    
                    let newsFeedList = try JSONDecoder().decode(NewsFeedList.self, from: data)
                    let newsFeed = newsFeedList.data.toArray()
                    if  NewsFeedViewModel.newsFeedList == nil {
                        DispatchQueue.main.async {
                            RealmDatabaseManager.shared.saveNewsFeedList(newsFeed)
                        }
                    }
                    NewsFeedViewModel.newsFeedList = newsFeedList
                    
                    completion(.success(newsFeed))
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            } else {
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
        }.resume()
    }
}
