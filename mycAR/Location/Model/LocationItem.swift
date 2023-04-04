//
//  LocationItem.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import Foundation
import MapKit

struct LocationItem: Equatable {
    let city: String?
    let state: String?
    let lat: Double?
    let long: Double?
}

extension LocationItem {
    init(dict: [String: AnyObject]) {
        self.city = dict["city"] as? String
        self.state = dict["state"] as? String
        self.lat = dict["latitude"] as? Double
        self.long = dict["longitude"] as? Double
    }
    
    var cityAndState: String {
        guard let city = self.city,
              let state = self.state
        else {
            return ""
        }
        return "\(city), \(state)"
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard let lat = lat, let long = long else {
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
