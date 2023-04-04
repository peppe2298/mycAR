//
//  CarListViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 08/12/22.
//

import UIKit

class CarListViewController: UIViewController, UICollectionViewDelegate {
    
    private let manager = CarDataManager()
    var selectedRCar: CarItem?
    var selectedCity: LocationItem?
    var selectedBrand: String?
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Creo i dati per la vista
        createData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Selected city \(selectedCity as Any)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segue.showDetail.rawValue:
                showCarDetail(segue: segue)
                break;
            default:
                print("Segue not added")
            }
        }
    }

}



//MARK: Private extension
private extension CarListViewController {
    
    //prende i dati dei ristoranti dal manager, se non vi sono ristorati da mostrare mostra la nodaview
    //dopodichè chiama la reloadData per aggiornatre la vista con la nuova view
    func createData() {
        guard let state = selectedCity?.state,
              let brand = selectedBrand
        else {
            return
        }
        
        manager.fetch(location: state, selectedBrand: brand) {
            carItems in
            if !carItems.isEmpty {
                collectionView.backgroundView = nil
            } else {
                let view = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
                view.set(title: "Ooooops", desc: "No cars found.")
                collectionView.backgroundView = view
            }
            collectionView.reloadData()
        }
        
    }
    
    
    func showCarDetail(segue: UIStoryboardSegue) {
        if let viewController = segue.destination as? CarDetailViewController,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            selectedRCar = manager.carItem(at: indexPath.row)
            viewController.selectedCar = selectedRCar
        }
    }
}



//MARK: UICollectionViewDataSource
extension CarListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Restituisco il numero di dati che ho ottenuto
        return manager.numberOfCarItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //la cella da restituire sarà una riusabile di tipo CarCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath) as! CarCell
        
        //Dall indice mi prendo l'auto che mi interessa
        let carItem = manager.carItem(at: indexPath.row)
        
        //Setto nome dell'auto e la marca
        cell.titleLabel.text = carItem.name
        if let cuisine = carItem.subtitle {
            cell.cuisineLabel.text = cuisine
        }
        
        
        if let carImage = carItem.image, carImage != "", let UICarImage =  UIImage(named: carImage) {
            cell.carImageView.image = UICarImage
        } else {
            cell.carImageView.image = UIImage(named: "all")
        }

        return cell
    }
    
}
