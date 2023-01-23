//
//  RealmDatabaseManager.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/22/23.
//

import Foundation
import RealmSwift

final class RealmDatabaseManager {
    
    private var localRealm: Realm {
        return RealmManager.shared.getNewRealm()
    }
    
    static let shared = RealmDatabaseManager()
    private var isSavingTouristsInLocalRealm: Bool = false
    private var isSavingTouristsPageInfoInLocalRealm: Bool = false
    private var isSavingNewsFeedListInLocalRealm: Bool = false
    private var isSavingNewsFeedPageInfoInLocalRealm: Bool = false
    
    // Do not allow any instances other than the singleton to be created
    internal init() {
    }
    
}

// MARK: - Save NewsFeedsPageInfo in Realm
extension RealmDatabaseManager {
    
    /// Save `NewsFeedPageInfo` in local realm
    func saveNewsFeedPageInfo(_ newsFeedPageInfo: NewsFeedPageInfo) {
        guard !isSavingNewsFeedPageInfoInLocalRealm else {
            return
        }
        
        isSavingNewsFeedPageInfoInLocalRealm = true
        
        do {
            try localRealm.write {
                localRealm.add(newsFeedPageInfo, update: .modified)
            }
        } catch {
            print("Error adding NewsFeedPageInfo object to Realm", error)
        }
        
        isSavingNewsFeedPageInfoInLocalRealm = false
    }
    
    /// Return`NewsFeedPageInfo`
    func getNewsFeedPageInfo() -> NewsFeedPageInfo? {
        let newsFeedPageInfo = localRealm.objects(NewsFeedPageInfo.self).last
        return newsFeedPageInfo
    }
}


// MARK: - Save NewsFeedList in Realm
extension RealmDatabaseManager {
    
    /// Save `NewsFeeds` in local realm
    func saveNewsFeedList(_ newsFeedList: [NewsFeedData]) {
        guard !isSavingNewsFeedListInLocalRealm else {
            return
        }
        
        isSavingNewsFeedListInLocalRealm = true
        
        let list = NewsFeedList()
        let itemsList = RealmSwift.List<NewsFeedData>()
        for item in newsFeedList {
            itemsList.append(item)
        }
        list.data = itemsList
        
        do {
            try localRealm.write {
                localRealm.add(list, update: .modified)
            }
        } catch {
            print("Error adding NewsFeedList object to Realm", error)
        }
        
        isSavingNewsFeedListInLocalRealm = false
    }
    
    /// Return`NewsFeedList`
    func getNewsFeedList() -> NewsFeedList? {
        let newsFeeds = localRealm.objects(NewsFeedList.self).last
        return newsFeeds
    }
}


// MARK: - Save Tourists page info in Realm
extension RealmDatabaseManager {
    
    /// Save `TouristPageInfo` in local realm
    func saveTouristsPageInfo(_ touristsPageInfo: TouristPageInfo) {
        guard !isSavingTouristsPageInfoInLocalRealm else {
            return
        }
        
        isSavingTouristsPageInfoInLocalRealm = true
        
        do {
            try localRealm.write {
                localRealm.add(touristsPageInfo, update: .modified)
            }
        } catch {
            print("Error adding TouristPageInfo object to Realm", error)
        }
        
        isSavingTouristsPageInfoInLocalRealm = false
    }
    
    /// Return`TouristPageInfo`
    func getTouristPageInfo() -> TouristPageInfo? {
        let touristPageInfo = localRealm.objects(TouristPageInfo.self).last
        return touristPageInfo
    }
}

// MARK: - Save Tourists in Realm
extension RealmDatabaseManager {
    
    /// Save `Tourists` in local realm
    func saveTouristsList(_ touristsList: [TouristData]) {
        guard !isSavingTouristsInLocalRealm else {
            return
        }
        
        isSavingTouristsInLocalRealm = true
        
        let list = Tourists()
        let itemsList = RealmSwift.List<TouristData>()
        for item in touristsList {
            itemsList.append(item)
        }
        list.data = itemsList
        
        do {
            try localRealm.write {
                localRealm.add(list, update: .modified)
            }
        } catch {
            print("Error adding Tourists object to Realm", error)
        }
        
        self.isSavingTouristsInLocalRealm = false
    }
    
    /// Return`Tourists`
    func getTouristsList() -> Tourists? {
        let tourists = localRealm.objects(Tourists.self).last
        return tourists
    }
}
