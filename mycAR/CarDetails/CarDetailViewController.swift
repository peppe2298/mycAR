//
//  CarDetailViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 10/12/22.
//

import UIKit
import MapKit
import QuickLook

class CarDetailViewController: UITableViewController {
    
    var selectedCar: CarItem?
    
    //Visualizzazione in tabella
    
   
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!

    @IBOutlet var price: UILabel!
    
    @IBOutlet var detailHeaderView: UIView!

    @IBOutlet var overallRatingLabel: UILabel!
   
    @IBOutlet var carDescription: UILabel!

    
    //Outlet per la customView delle stelle
    @IBOutlet var ratingsView: RatingsView!
    
    var ARBundleUrl: URL!
    
    
    @IBAction func ShowARPressed(_ sender: Any) {
        showARObject()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    //una volta apparsa la view aggiorno anhe il rating dell'auto
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createRating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segue.showReview.rawValue:
                showReview(segue: segue)
            default:
                print("segue not added")
            }
        }
    }


}


//MARK: private extension
private extension CarDetailViewController {
    
    func initialize() {
        setupLabels()
        //        createMap()
        createRating()
    }
    
    @IBAction func unwindReviewCancel(segue: UIStoryboardSegue) {
        
    }
    
    func showReview(segue: UIStoryboardSegue){
        guard let navController = segue.destination as? UINavigationController,
              let viewController = navController.topViewController as? ReviewFormViewController
        else{
            return
        }
        viewController.selectedCarID = selectedCar?.carID
    }

    
    func createRating() {
        ratingsView.rating = 3.5
        ratingsView.isEnabled = false
        if let carID = selectedCar?.carID {
            let ratingValue = CoreDataManager.shared.fetchCarRating(by: carID)
            ratingsView.rating = ratingValue
            if ratingValue.isNaN {
                overallRatingLabel.text = "0.0"
            } else {
                let roundedValue = ((ratingValue * 10).rounded() / 10)
                overallRatingLabel.text = "\(roundedValue)"
            }
        }
    }
    
    //Se ho i dati del ristorate selezionato quando entro in questa viewController allora inizializzo le labels con i dati dell'auto
    func setupLabels() {
        guard let car = selectedCar
        else {
            return
        }
        title = car.name
        nameLabel.text = car.name
        brandLabel.text = car.subtitle
        carDescription.text = car.carDescription
        price.text = String(format: "%.2f", car.price!) + " $"
        
        //Se non ho l'immagine non mostro il logo blurrato ma mi limito al grigio
        if let image = car.image, image != "", let UICarImage =  UIImage(named: image) {
            //Resize immagine auto in modo che abbia le stesse dimensioni della vista
            UIGraphicsBeginImageContext(detailHeaderView.frame.size)
            UICarImage.draw(in: detailHeaderView.bounds)
            
            
            
            //Se il resize va a buon fine applico il filtro blur all'immagine
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext(){
                UIGraphicsEndImageContext()

                //Immagine iniziale in formato CI (Solo proprietà immagine)
                let ciImage = CIImage(image: resizedImage, options: nil)
                
                //Prendo il filtro dalla classe built-in passandone il nome
                guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {
                    print("Filter not found")
                    return
                }
                
                //Passo al filtro le proprietà dell'immagine da modificare ed eventuali parametri, in questo caso il livello di blur da applicare
                blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
                blurFilter.setValue(5.0, forKey: kCIInputRadiusKey)
                
                //Dal filtro ricavo le nuove proprietà con il filtro applicato
                let filteredCIImage = (blurFilter.outputImage)!
                let contex = CIContext()
                
                //Tramite il contex estrapolo le nuove proprietà immagine con il filtro applicato e creo quindi una nuova immagine partendo da loro
                let filteredCGImage = contex.createCGImage(filteredCIImage, from: filteredCIImage.extent)
                detailHeaderView.backgroundColor = UIColor(patternImage: UIImage(cgImage: filteredCGImage!))
            }else {
                UIGraphicsEndImageContext()
            }
        }

    }
    
    func showARObject() {
        let resourceName = selectedCar?.ARFile
        
        
        //Se trovo il modello 3D tramite Bundle main url allora lancio la quick look con allínterno lóggetto da vedere in AR
        //Altrimenti ritorno errore
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz") else {
            let alertController = UIAlertController(title: "Ooops", message: "Modello 3D non ancora disponibile", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        ARBundleUrl = url
        let previewcontroller = QLPreviewController()
        previewcontroller.dataSource = self
        previewcontroller.delegate = self
        
        present(previewcontroller, animated: false)
    }
    
}
    
    
//MARK: QuickLook extension
extension CarDetailViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {

        return ARBundleUrl as QLPreviewItem
    }
    
    
}
