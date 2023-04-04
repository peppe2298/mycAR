//
//  MapDataManager.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import Foundation
import MapKit

class MapDataManager : DataManager {
    
    private var items: [LocationAnnotation] = []
    
    //Creo una copia di items faccio in modo che l'array sia accessibile ma non modificabile
    var annotations: [LocationAnnotation] {
        items
    }
    
    func fetch(completion: (_ annotations: [LocationAnnotation]) -> ()) {
        let manager = LocationDataManager()
        manager.fetch(completionHandler: {
            (locationItems) in
                
                let locationAnnotations = locationItems.map { locationItem in
                    return LocationAnnotation(coordinate: locationItem.coordinate, city: locationItem.city, state: locationItem.state)
                }
                
                self.items = locationAnnotations
                return completion(self.annotations)
            
        })
    }
    
    func initialRegion(latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) -> MKCoordinateRegion {
        
        guard let item = items.first else {
            return MKCoordinateRegion()
        }
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        return MKCoordinateRegion(center: item.coordinate, span: span)
    }
}
