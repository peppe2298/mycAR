//
//  RatingsView.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 12/12/22.
//

import UIKit

class RatingsView: UIControl {

    //Mi prendo le immagini archiviate nell Assets.xcassets
    private let filledStarImage = UIImage(named: "filled-star")
    private let halfStarImage = UIImage(named: "half-star")
    private let emptyStarImage = UIImage(named: "empty-star")
    
    //Numero totale di stelle e valutazione
    //In questo caso ho impostato un observer che aggiorna il display ogni volta che viene rating è stata aggiornata (settata)
    private var totalStars = 5
    var rating = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    //Abilitare eventi con il tocco: he neccessario che la view possa diventare firstResponder
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    //con la view che può diventare first responder mi accerto se devo abilitare il track o no, controllando da una variabile custom in questo caso
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard self.isEnabled else {
            return false
        }
        super.beginTracking(touch, with: event)
        handle(with: touch)
        return true
    }
    
    
    //Metodo che si occupa di disegnare la view
    override func draw(_ rect: CGRect) {
        //Crea la "lavagna" su cui andrai a disegnare il componente
        let context = UIGraphicsGetCurrentContext()
        
        //setto il colore del riempimento al colore dello sfondo di sistema e riempio il rettangolo
        context!.setFillColor(UIColor.systemBackground.cgColor)
        context!.fill(rect)
        
        
        //Setto la dimensione che avranno le stelle:
        //Prendo la lunghezza della view e la divido per il numero di stelle
        let ratingViewWidth = rect.size.width
        let availableWidthForStar = ratingViewWidth / Double(totalStars)
        
        //Voglio che le stelle stiano in un quadrato, quindi se la lunghezza disponibile supera l'altezza come lunghezza del lato seleziono l'altezza,
        //Altrimenti prendo tutta quella disponibile
        let starSidelenght = (availableWidthForStar <= rect.size.height) ? availableWidthForStar : rect.size.height
        
        
        //Disegno le stelle iterandole in un ciclo for
        for index in 0..<totalStars {
            
            //availableWidthForStar * Double(index) serve a determinare il punto d'inizio dove disegnare, le operazioni /2 servono per centrare la stella dividendo l'eccedentra tra destra e sinistra
            let starOriginX = (availableWidthForStar * Double(index)) + ((availableWidthForStar - starSidelenght) / 2)
            let starOriginY = ((rect.size.height - starSidelenght) / 2)
            
            //Genero il frame (in questo caso corrisponde al quadratino) in cui andrò a disegnare la stella
            let frame = CGRect(x: starOriginX, y: starOriginY, width: starSidelenght, height: starSidelenght)
            
            //Stabilisco qualee immagine devo inserire:
            //Se sono sotto sotto il rating allora va tutta, se sono sotto il rating arrotondato per difetto va a metà altrimenti vuoto
            var starToDraw: UIImage!
            if (Double(index + 1) <= self.rating) {
                starToDraw = filledStarImage
            } else if (Double(index + 1) <= self.rating.rounded()){
                starToDraw = halfStarImage
            } else {
                starToDraw = emptyStarImage
            }
            starToDraw.draw(in: frame)
        }
    }
    
    

}

//MARK: private extension
private extension RatingsView {
    
    //funzione che calcola il voto in base al tocco effettuato
    func handle(with touch: UITouch) {
        let starRectWidth = self.bounds.size.width / Double(totalStars)
        let location = touch.location(in: self)
        var value = location.x / starRectWidth
        if (value + 0.5) < value.rounded(.up) {
            value = floor(value) + 0.5
        } else {
            value = value.rounded(.up)
        }
        updateRating(with: value)
    }
    
    
    //Aggiorno il rating nell'apposita variabile
    func updateRating(with newValue: Double) {
        if (self.rating != newValue && newValue >= 0 && newValue <= Double(totalStars)) {
            self.rating = newValue
        }
    }
    
    
}
