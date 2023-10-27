//
//  AReXViewController.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 25/03/23.
//

import UIKit
import RealityKit

class AReXViewController: UIViewController {
    
    var carAnchor: PlayCar._PlayCar?
    var forwardTimer: Timer?
    var backTimer: Timer?
    var rightTimer: Timer?
    
    var leftTimer: Timer?

    
    @IBOutlet var arview: ARView!
    @IBOutlet var carRight: UIButton!
    @IBOutlet var carLeft: UIButton!
    @IBOutlet var carForward: UIButton!
    @IBOutlet var carBack: UIButton!
    
    var isActionPlaying: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inizializzo e mostro il tank
        initializeCar()
        showCar()
    }
    
    
    //Ad ogni pressione di un tasto eseguo un azione
    @IBAction func carRghtPressed(_ sender: Any) {
        
        startRepeatedAction(&rightTimer, CarAction.carRight.rawValue)
        
    }
    
    @IBAction func carLeftPressed(_ sender: Any) {
        startRepeatedAction(&leftTimer, CarAction.carLeft.rawValue)
    }
    
    @IBAction func carForwardPressed(_ sender: Any) {
        startRepeatedAction(&forwardTimer, CarAction.carForward.rawValue)
    }
    
    @IBAction func carBackPressed(_ sender: Any) {
        startRepeatedAction(&backTimer, CarAction.carBack.rawValue)
    }
    
    @IBAction func carRghtReleased(_ sender: Any) {
        stopRepeatedAction(&rightTimer)
    }
    
    @IBAction func carLeftReleased(_ sender: Any) {
        stopRepeatedAction(&leftTimer)
    }
    
    @IBAction func carForwardReleased(_ sender: Any) {
        stopRepeatedAction(&forwardTimer)
    }
    
    @IBAction func carBackReleased(_ sender: Any) {
        stopRepeatedAction(&backTimer)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//MARK extension
private extension AReXViewController {
    
    func initializeCar() {
        
        //recupero il composer porject e lo setto nella variabile TankAnchor
        carAnchor = try! PlayCar.load_PlayCar()
        
        
        //setto un listener che ad ogni azione completata mi riporta
        //la variabile isActionPlaying a false, in modo
        //da poter compiere una nuova azione
        carAnchor?.actions.actionComplete.onAction = { _ in
            self.isActionPlaying = false
        }
    }
    
    func showCar() {
        //Appendo alla scenda creata in ARview l'oggetto tank
        arview.scene.anchors.append(carAnchor!)
    }
    
    func startRepeatedAction(_ timer: inout Timer?, _ action: String) {
        guard timer == nil else{
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in self.executeTankAction(action) })
    }
    
    func stopRepeatedAction(_ timer: inout Timer?) {
        timer?.invalidate()
        timer = nil
    }
    
    func executeTankAction(_ action: String) {
        
        //Se un azione è in corso mi limito ainterrompere,
        //altrimenti dichiaro che sto compiendo un azione e in base all'enumeratore la eseguo
        
        if self.isActionPlaying {return}
        
        self.isActionPlaying = true
        
        switch (action) {
        case CarAction.carRight.rawValue:
            carAnchor!.notifications.carRight.post()
            break;
        case CarAction.carLeft.rawValue:
            carAnchor!.notifications.carLeft.post()
            break;
        case CarAction.carForward.rawValue:
            carAnchor!.notifications.carForward.post()
            break;
        case CarAction.carBack.rawValue:
            carAnchor!.notifications.carBack.post()
            break;
        default:
            break;
        }
    }
}
