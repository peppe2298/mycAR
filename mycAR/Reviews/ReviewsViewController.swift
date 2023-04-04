//
//  ReviewsViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 17/12/22.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var selectedCarID: Int?
    private var reviewItems: [ReviewItem] = []
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd, yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkReviews()
    }
    
}


//MARK: private extension
private extension ReviewsViewController {
    func initialize() {
        setupCollectionView()
    }
    
    //setto il layout della collection view che conterrà tutte e recensioni
    func setupCollectionView(){
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 7
        flow.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flow
    }
    
    func checkReviews() {
        
        //Mi prendo il parent della videata  e se sono sicuro essere il dettaglio dell'auto allora lo uso per prendermi il suo carID
        let viewController = self.parent as? CarDetailViewController
        if let carID = viewController?.selectedCar?.carID {
            
            //se ho il carId posso chiamare la fetch che mi trova le recensioni per quell'auto
            reviewItems = CoreDataManager.shared.fetchReviews(by: carID)
            if !reviewItems.isEmpty {
                collectionView.backgroundView = nil
            } else {
                //se non ci sono recensioni setto come sfondo della view una nuova view con le dimensioni della mia in cui dico che non ci sono dati da visualizzare
                let view = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
                view.set(title: "Reviews", desc: "There are no currently reviews")
                collectionView.backgroundView = view
            }
        }
        
        //Una volta fatto tutto devo riaggiornare il dsettaglio dell'auto per far comparire le nuove recensioni
        collectionView.reloadData()
    }
}

extension ReviewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reviewItems.count
    }
    
    //per la costruzione della cella porende il modello, ottenuto dalla fetch, dall'array alla posizione che gli serve e lo popola con i campi di interesse
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        let reviewItem = reviewItems[indexPath.item]
        cell.nameLabel.text = reviewItem.name
        cell.titleLabel.text = reviewItem.title
        cell.reviewLabel.text = reviewItem.customerReview
        if let reviewItemDate = reviewItem.date {
            cell.dateLabel.text = dateFormatter.string(from: reviewItemDate)
        }
        cell.ratingsView.isEnabled = false
        if let reviewItemRating = reviewItem.rating {
            cell.ratingsView.rating = reviewItemRating
        }
        return cell
    }
    
}

extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edgeInset = 7.0
        if reviewItems.count == 1 {
            let cellWidth = collectionView.frame.size.width - (edgeInset * 2)
            return CGSize(width: cellWidth, height: 200)
        } else {
            let cellWidth = collectionView.frame.size.width - (edgeInset * 3)
            return CGSize(width: cellWidth, height: 200)
        }
    }
}
