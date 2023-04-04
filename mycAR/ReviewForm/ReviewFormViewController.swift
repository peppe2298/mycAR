//
//  ReviewFormViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 12/12/22.
//

import UIKit

class ReviewFormViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedCarID as Any)
    }

    @IBOutlet var ratingsView: RatingsView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var reviewTextView: UITextView!
    
    //verrà passato dalla schermata del dettaglio della macchina
    var selectedCarID: Int?
    
    
    //crea il model popoilato della recensione e usa la classe statica del coredatamanager per salvarla
    @IBAction func onSaveTapped(_sender: Any) {
        var reviewItem = ReviewItem()
        reviewItem.rating = ratingsView.rating
        reviewItem.title = titleTextField.text
        reviewItem.name = nameTextField.text
        reviewItem.customerReview = reviewTextView.text
        
        if let selRestId = selectedCarID {
            reviewItem.carId = Int64(selRestId)
        }
        
        CoreDataManager.shared.addReview(reviewItem)
        
        dismiss(animated: true, completion: nil)
    }

}
