//
//  CoreDataManager.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 17/12/22.
//

import Foundation
import CoreData

struct CoreDataManager {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Data Model")
        container.loadPersistentStores { (storeDesc, error) in
            error.map {
                print($0)
            }
        }
    }
    
    //prende un oggetto review vuoto, lo popola con i dati del suo model e lo salva
    func addReview(_ reviewItem: ReviewItem) {
        let review = Review(context: container.viewContext)
        review.date = Date()
        
        if let reviewItemRating = reviewItem.rating {
            review.rating = reviewItemRating
        }
        review.title = reviewItem.title
        review.name = reviewItem.name
        review.customerReview = reviewItem.customerReview
        
        if let revieItemRestId = reviewItem.carId {
            review.carID = revieItemRestId
        }
        review.uuid = reviewItem.uuid
        save()
    }
    
    
    //salvataggio dell'oggetto (istanza del model situata nel context) nel persistentStore
    private func save() {
        do {
            if container.viewContext.hasChanges {
                try container.viewContext.save()
            }
        }catch let error{
            print(error.localizedDescription)
        }

    }
    
    func fetchReviews(by identifier: Int) -> [ReviewItem] {
        //prendo un riferimento allístanza di nsContext (una specie di ambiente di lavoro per entità
        let moc = container.viewContext
        //creo una fetch request dell'oggetto in questione
        let request = Review.fetchRequest()
        
        //Sarebbe una forma di query
        let predicate = NSPredicate(format: "carID = %i", identifier)
        
        var reviewItems: [ReviewItem] = []
        
        
        //popolo la fetch request con ordinamento e query e il risulato lo carico nell'array che restituirò
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = predicate
        do{
            for review in try moc.fetch(request) {
                reviewItems.append(ReviewItem(review: review))
            }
            return reviewItems
        }catch {
            fatalError("failed to fetch review /(error)")
        }
        
    }

    
    func fetchCarRating(by identifier: Int) -> Double {
        let reviewItems = fetchReviews(by: identifier)
        let sum = reviewItems.reduce(0, {$0 + ($1.rating ?? 0)})
        return sum / Double(reviewItems.count)
    }
}
