//
//  String+Extensions.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import UIKit

extension String {
    
    /// Return date string to display
    func getDateString() -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMM dd,yyyy HH:mm:ss a"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterDisplay.string(from: date)
        }
        
        return nil
    }
}
