//
//  LocationViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let manager = LocationDataManager()
    var selectedCity: LocationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

    }
    
    private func setCheckmark(for cell: UITableViewCell, location: LocationItem) {
        if selectedCity == location {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
}


//MARK: Private extension
private extension LocationViewController {
    func initialize() {
        manager.fetch()
    }
}


//MARK: UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.numberOfLocationItems()
    }
    
    //Questa funzione viene richiamata quando renderizzo le celle, in questo modo faccio in modo che
    //l'unica cell che avrà la spunta sarà la corrispondente alla selectedCity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let location =  manager.locationItem(at: indexPath.row)
        cell.textLabel?.text = location.cityAndState
        setCheckmark(for: cell, location: location)
        return cell
    }
}

//MARK: UITableviewDelegate
extension LocationViewController: UITableViewDelegate {
    
    //quando viene selezionata una riga tella tabella Tableview alla riga indexpath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedCity = manager.locationItem(at: indexPath.row)
            
            //ricarico tutte le celle per eliminare eventuali altre spunte
            tableView.reloadData()
        }
    }
}
