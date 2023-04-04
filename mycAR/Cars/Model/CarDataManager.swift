//
//  CarDataManager.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import Foundation

class CarDataManager {
    
    private var carItems: [CarItem] = []
    
    func fetch(location: String, selectedBrand: String = "All", completionHandler: (_ carItems: [CarItem]) -> Void) {
        if let file = Bundle.main.url(forResource: location, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let cars = try JSONDecoder().decode([CarItem].self, from: data)
                if selectedBrand != "All" {
                    carItems = cars.filter {
                        ($0.brand.contains(selectedBrand))
                    }
                } else {
                    carItems = cars
                }
            } catch {
                print("There was an error \(error)")
            }
        }
        
        return completionHandler(carItems)
    }
    
    func numberOfCarItems() -> Int{
        return carItems.count
    }
    
    func carItem(at index: Int) -> CarItem {
        carItems[index]
    }
}
