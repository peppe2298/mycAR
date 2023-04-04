//
//  CarItem.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import UIKit
import MapKit

class CarItem: NSObject, Decodable {
    
    
    let name: String?
    let brand: String
    let carDescription: String?
    let price: Double?
    let image: String?
    let carID: Int?
    let ARFile: String?
    
    init(name: String?, brand: String?, carDescription: String?, price: Double?, image: String?, carID: Int?, ARFile: String?) {
        self.name = name
        self.brand = brand!
        self.carDescription = carDescription
        self.price = price
        self.image = image
        self.carID = carID
        self.ARFile = ARFile
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
                
        self.name = try values.decode(String.self, forKey: .name)
        self.brand = try values.decode(String.self, forKey: .brand)
        self.carDescription = try values.decode(String.self, forKey: .carDescription)
        self.price = try values.decode(Double.self, forKey: .price)
        self.image = try values.decode(String.self, forKey: .image)
        self.carID = try values.decode(Int.self, forKey: .carID)
        self.ARFile = try values.decode(String.self, forKey: .ARFile)
        
    }
    
    enum CodingKeys: String, CodingKey {

        case name
        case brand
        case price
        case carDescription = "description"
        case image = "image_name"
        case carID = "id"
        case ARFile
    }
    
    
    var title: String? {
        name
    }
    
    var subtitle: String? {
        return brand
    }
}
