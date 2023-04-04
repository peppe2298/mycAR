//
//  NoDataView.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 11/12/22.
//

import UIKit


//Questa classe viene collegata al file owner dello xib file
class NoDataView: UIView {

    //Outlet che verranno assegnati (noodataview, Label titolo e label descrizione)
    var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    
    //una sottoclasse di UIView ha due init
    //Il primo gestisce la creazione della view da codice, il secondo si collega al file xib
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    //Carica il nodataView xib file e prende la vista al suo interno
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "NoDataView", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: self, options: nil) [0] as! UIView
        return view
    }
    
    
    //Prende la vista dallo xib file, setta le dimensioni dello schermo e aggiunge la vista del xib come sottovista
    func setupView() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func set(title: String, desc: String) {
        titleLabel.text = title
        descLabel.text = desc
    }

}
