//
//  LocationDataManager.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import Foundation


class LocationDataManager: DataManager {
    private var locations: [LocationItem] = []
    
    /*
    private func loadData() -> [[String: String]] {
        let decoder = PropertyListDecoder()
        if
            let path = Bundle.main.path(forResource: "Locations", ofType: "plist"),
            let locationsData = FileManager.default.contents(atPath: path),
            let locations = try? decoder.decode([[String: String]].self, from: locationsData) {
                return locations
            }
        return [[:]]
    }*/
    
    func fetch() {
        for location in loadPlist(file: "Locations") {
            locations.append(LocationItem(dict: location))
        }
    }
    
    func fetch(completionHandler: (_ carItems: [LocationItem]) -> Void) {
        fetch()
        return completionHandler(locations)
    }
    
    func numberOfLocationItems() -> Int {
        return locations.count
    }
    
    func locationItem(at index: Int) -> LocationItem {
        return locations[index]
    }
}
