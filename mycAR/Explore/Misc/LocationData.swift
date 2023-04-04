//
//  LocationData.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 27/03/23.
//

import Foundation

enum LocationDatafile: String {
    case other = ""
    case Italia = "ITBrands"
    case Svezia = "SEBrands"
    case StatiUniti = "USBrands"
    case Germania = "DEBrands"
    case Inghilterra = "UKBrands"
    case Giappone = "JPBrands"
    
    
    init(value: String) {
        switch (value) {
        case "Italia":
            self = LocationDatafile.Italia
            break;
        case "Svezia":
            self = LocationDatafile.Svezia
            break;
        case "Stati Uniti":
            self = LocationDatafile.StatiUniti
            break;
        case "Regno Unito":
            self = LocationDatafile.Inghilterra
            break;
        case "Germania":
            self = LocationDatafile.Germania
            break;
        case "Giappone":
            self = LocationDatafile.Giappone
            break;
        default:
            self = LocationDatafile.other
            break;
        }
    
    }
}
