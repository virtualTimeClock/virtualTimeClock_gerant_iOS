//
//  MissionDetailController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/4/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import Firebase

class MissionDetailController: UIViewController {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var mdetailsLB: UILabel!
    @IBOutlet weak var titreLB: UILabel!
    @IBOutlet weak var debLB: UILabel!
    @IBOutlet weak var finLB: UILabel!
    @IBOutlet weak var lieuLB: UILabel!
    @IBOutlet weak var latLB: UILabel!
    @IBOutlet weak var longLB: UILabel!
    @IBOutlet weak var descLB: UILabel!
    @IBOutlet weak var rayonLB: UILabel!
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var deb: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var lieu: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var rayon: UILabel!
    
    var mission: Mission? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recuperation des strings
        titre.text = mission?.titre
        lieu.text = mission?.lieu
        desc.text = mission?.description
        
        
        // Récupération des dates
        let debDB:Date = mission!.debut
        let dat = DateFormatter()
        dat.dateStyle = .short
        dat.timeStyle = .short
        let debutST = dat.string(from: debDB)
        deb.text = debutST
        
        let finDB:Date = mission!.fin
        let dat2 = DateFormatter()
        dat2.dateStyle = .short
        dat2.timeStyle = .short
        let finST = dat2.string(from: finDB)
        fin.text = finST

        
        // Recuperation des coordonnees
        let latDB:Double = mission!.latitude
        let lati:String = String(format:"%f", latDB)
        lat.text = lati
        
        let longDB:Double = mission!.longitude
        let longi:String = String(format:"%f", longDB)
        long.text = longi
        
        // Recuperation du rayon
        
        let rayonDB:Double = mission!.rayon
        let ray:String = String(format:"%f", rayonDB)
        rayon.text = ray
        
        
    }
    

    

}
