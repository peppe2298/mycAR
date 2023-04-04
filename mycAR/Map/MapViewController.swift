//
//  MapViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    private let manager = MapDataManager()
    var selectedCity: LocationAnnotation?
    
    let identifier = "custompin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.showBrands.rawValue:
//            showExploreList(segue: segue)
            break;
        default:
            print("Segue not added")
        }
    }
    
    
    

}

//MARK: Private extension
private extension MapViewController {
    
    func showExploreList(withSelectedCity locationItem: LocationItem?) {
        
        //setto il tab explore
        let tabBarController = self.tabBarController
        
        tabBarController?.selectedIndex = 0
        
        let navigationView = tabBarController?.selectedViewController as? UINavigationController
        let city = locationItem
        var selectedView = navigationView?.topViewController as? ExploreViewController
        
        
        if navigationView != nil, selectedView == nil
        {
            navigationView?.popToRootViewController(animated: true)
            selectedView = navigationView?.topViewController as? ExploreViewController
        }
        
        
        if navigationView != nil, city != nil, selectedView != nil
        {
            selectedView?.selectedCity = city
            selectedView?.headerView.locationLabel.text = city?.cityAndState
            selectedView?.manager.fetch(locationData: city?.city ?? "")
            selectedView?.collectionView.reloadData()
        }

        
        
    }
    
    func setupMap(_ annotations: [LocationAnnotation]) {
        mapView.mapType = .satelliteFlyover
        mapView.setRegion(manager.initialRegion(latDelta: 80, longDelta: 80), animated: true)
        mapView.addAnnotations(annotations)
        
    }
    
    
    
    
    func initialize() {
        mapView.delegate = self
        manager.fetch { (annotations) in
            setupMap(annotations)
        }
    }
}

//MARK: MKMapviewDelegate
extension MapViewController: MKMapViewDelegate {
    
    
    //Metodo per sostituire il pin di default con uno custom
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Non modificherò pin di tipo userLocation
        guard !annotation.isKind(of: MKUserLocation.self)
        else {
            return nil
        }
        
        //Creo la variabile annotationView che verrà restituita ala fine della funzione
        let annotationView: MKAnnotationView
        
        //faccio un check se ci sono delle annotazioni (con il mio identifier) che sono state inizializzate ma non sono più visibili nella mappa,
        //se le trovo le riutilizzo altrimenti dovrò creare una nuova annotazione da zero
        if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = customAnnotationView
            annotationView.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        
        //aggiungo informazioni extra al pin e centro bene come l'immagine custom per il pin verrà visualizzata (Di defaul viene messo il pin al centro dell'immagine)
        annotationView.canShowCallout = true
        if let image = UIImage(named: "custom-annotation") {
            annotationView.image = image
            annotationView.centerOffset = CGPoint(x: -image.size.width / 2, y: -image.size.height / 2)
        }
        return annotationView
    }
    
    
    //Viene richiamato quando premi la bubble nella mappa
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = mapView.selectedAnnotations.first
        else {
            return
        }
        
        selectedCity = annotation as? LocationAnnotation
        showExploreList(withSelectedCity: (selectedCity?.generateLocationItem())!)
        mapView.deselectAnnotation(annotation, animated: true)
//        self.performSegue(withIdentifier: Segue.showBrands.rawValue, sender: self)
    }
}
