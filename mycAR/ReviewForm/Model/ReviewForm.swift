//
//  ReviewForm.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 17/12/22.
//


import UIKit
import Foundation

//Inizializzo il model per l'entità delle revisioni e il suo costruttore (init)
struct ReviewItem {
    var date: Date?
    var rating: Double?
    var title: String?
    var name: String?
    var customerReview: String?
    var carId: Int64?
    var uuid = UUID()
}


extension ReviewItem {
    init(review: Review) {
        self.date = review.date
        self.rating = review.rating
        self.title = review.title
        self.name = review.name
        self.customerReview = review.customerReview
        self.carId = review.carID
        if let reviewUUID = review.uuid {
            self.uuid = reviewUUID
        }
    }
}
