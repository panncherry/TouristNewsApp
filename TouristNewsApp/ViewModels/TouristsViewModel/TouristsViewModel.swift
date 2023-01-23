//
//  TouristsViewModel.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//
import UIKit
import RealmSwift

/// Tourists ViewModel
class TouristsViewModel: NSObject, TouristsViewModelProtocol {
    
    static let shared = TouristsViewModel()
    
    static var touristsList: Tourists?
    
    static var touristsPageInfo: TouristPageInfo?
    
    /// Fetch tourists data for input page number
    func fetchTouristsData(for page: Int,
                           completion: @escaping (Result<[TouristData], Error>)-> ()) {
        guard let url = URL(string: "\(BaseURLs.touristsURL)\(page)") else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let touristPageInfo = try JSONDecoder().decode(TouristPageInfo.self, from: data)
                if TouristsViewModel.touristsPageInfo == nil {
                    DispatchQueue.main.async {
                        RealmDatabaseManager.shared.saveTouristsPageInfo(touristPageInfo)
                    }
                }
                TouristsViewModel.touristsPageInfo = touristPageInfo
                
                
                let touristList = try JSONDecoder().decode(Tourists.self, from: data)
                let list = touristList.data.toArray()
                if  TouristsViewModel.touristsList == nil {
                    DispatchQueue.main.async {
                        RealmDatabaseManager.shared.saveTouristsList(list)
                    }
                }
                TouristsViewModel.touristsList = touristList
                
                completion(.success(list))
                
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
        }.resume()
    }
}
