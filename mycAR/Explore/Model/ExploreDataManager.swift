//
//  ExploreDataManager.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 09/12/22.
//

import Foundation

class ExploreDataManager : DataManager{
    
    
    
    //Array che conterrà i dati presi dalla plist e li manterrà nel manager
    private var exploreItems: [ExploreItem] = []
    
    //un funzione incaricata di prendere i dati dal plist e trasformarli in array di ExploreItem
    func fetch(locationData location: String ) {
        exploreItems = []
        let locationDataName = LocationDatafile.init(value: location)
        
        for data in loadPlist(file: "AllBrands") {
            exploreItems.append(ExploreItem(dict: data as! [String: String]))
        }
        
        for data in loadPlist(file: locationDataName.rawValue) {
            //per ogni dato preso con la funzione loadData instanzio un oggetto di tipo eploreItem e lo inserisco nell'array exploreItems
            //in ExploreItem è stato fatto un costruttore con un dizionario in input
            exploreItems.append(ExploreItem(dict: data as! [String: String]))
        }
    }
    
    
    func numberOfExploreItems() -> Int {
        return exploreItems.count
    }
    
    func exploreItem(at index: Int) -> ExploreItem {
        exploreItems[index]
    }
    
    

}
