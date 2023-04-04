//
//  LocationAnnotation.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 28/03/23.
//

import Foundation
import MapKit


class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String? {
        city
    }
    
    var subtitle: String? {
        return state
    }
    
    let city: String?
    let state: String?
    
    init(coordinate: CLLocationCoordinate2D, city: String?, state: String?) {
        self.coordinate = coordinate
        self.city = city
        self.state = state
    }
    
    func generateLocationItem() -> LocationItem {
        
        return LocationItem(city: city, state: state, lat: coordinate.latitude, long: coordinate.longitude)
        
    }
}
