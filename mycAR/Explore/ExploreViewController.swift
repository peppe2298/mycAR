//
//  ExploreViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 08/12/22.
//

import UIKit

class ExploreViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    let manager = ExploreDataManager()
    var selectedCity: LocationItem?
    var headerView: ExploreHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    

    
    //Controllo per accertarsi che il segue sia effettivamente eseguibile;
    //Se non ho selezionato una località e voglio accedere alla lista dei ristoranti non posso proseguire
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Segue.carList.rawValue,
           selectedCity == nil {
            showLocationRequiredAlert()
            return false
        }
        
        return true
    }
    
    
    //Preparo l'explore controller view al cambio schermata;
    //In base alla viewController di destinazione richiamo la funzione che prepara i dati per quell'apposita viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case Segue.locationList.rawValue:
                showLocationList(segue: segue)
            case Segue.carList.rawValue:
                showCarList(segue: segue)
            default:
                print("Segue not added")
        }
    }

}

//MARK: Private extension
private extension ExploreViewController {
    func initialize() {
        // istanzio l'explore data manager che mi permetterà di prendere i dati dal plist
        manager.fetch(locationData: selectedCity?.city ?? "")
    }
    
    @IBAction func unWindLocationCancel(segue: UIStoryboardSegue) {
        
    }
    
    //Quando premerò sul tasto Done nell locationView allora viene richiamata questa funzione che setterà la località selezionata
    //nel subtitle dell'header e chiuderà la locationTableView
    @IBAction func unWindLocationDone(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? LocationViewController {
            selectedCity = viewController.selectedCity
            if let location = selectedCity {
                headerView.locationLabel.text = location.cityAndState
            }
            initialize()
            self.collectionView.reloadData()
        }
    }
    
    
    //Quando passo dalla explore view alle location imposto la selectedCity
    //in modo che renderizzando le celle possa comparire la spunta sulla città precedentemente selezionata
    func showLocationList(segue: UIStoryboardSegue) {
        
        //In una navigationController ho un array di tutte le sue viewcontroller visualizzate
        //con topViewController posso prendermi l'ultima viewController ad esser stata visualizzata
        //
        guard let navcontroller = segue.destination as? UINavigationController,
              let viewController = navcontroller.topViewController as? LocationViewController
        else {
            return
        }
        
        viewController.selectedCity = selectedCity
    }
    
    //Stesso concetto di show location list:
    //al clic prendo i dati di cio che ho selezionato e se la viewcontroller di destinazione risulta essere
    //di tipo CarListViewcontroller le passo insieme anche cuisine selezionata e località (salvata nell'header)
    func showCarList(segue:UIStoryboardSegue) {
        if let viewController = segue.destination as? CarListViewController,
           let city = selectedCity,
           let index = collectionView.indexPathsForSelectedItems?.first?.row {
            viewController.selectedBrand = manager.exploreItem(at: index).name
            viewController.selectedCity = city
        }
    }
    
    func showLocationRequiredAlert() {
        let alertController = UIAlertController(title: "Location needed", message: "Please select a location.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        headerView = header as? ExploreHeaderView
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.numberOfExploreItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExploreCell
        let exploreItem = manager.exploreItem(at: indexPath.row)
        cell.exploreNameLabel.text = exploreItem.name
        if let itemImage = exploreItem.image {
            cell.exploreImageView.image = (itemImage != "") ? UIImage(named: itemImage) : UIImage(named: "all")
        }
        
        return cell
    }}

