//
//  MissionDetailController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/4/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class MissionDetailController: UIViewController, AVAudioPlayerDelegate {
    
    
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
    @IBOutlet weak var rayon: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    
    @IBOutlet weak var buttonMission: UIButton!
    
    var player: AVAudioPlayer!
    
    var mission: Mission? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            fatalError("⛔️ Aucun utilisateur n'est connecté !")
        }
        
        setupButton()
        
        //Affichage
        titreLB.text = NSLocalizedString("titre", comment: "Labels")
        debLB.text = NSLocalizedString("debut", comment: "Labels")
        finLB.text = NSLocalizedString("fin", comment: "Labels")
        lieuLB.text = NSLocalizedString("lieu", comment: "Labels")
        latLB.text = NSLocalizedString("latitude", comment: "Labels")
        longLB.text = NSLocalizedString("longitude", comment: "Labels")
        rayonLB.text = NSLocalizedString("rayon", comment: "Labels")
        descLB.text = NSLocalizedString("desc", comment: "Labels")
        
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
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPointEmp" {
            let destination = segue.destination as! ListPointEmpController
            destination.missionID = mission!.id
        }
    }
    
    // MARK: Private functions
    
    private func setupButton(){
        buttonMission.layer.cornerRadius = 16
        
    }
    
    private func mediaPlayer(son: String) {
        // On va jouer le son
        if let soundFilePath = Bundle.main.path(forResource: son, ofType: "mp3") {
            let fileURL = URL(fileURLWithPath: soundFilePath)
            do {
                try self.player = AVAudioPlayer(contentsOf: fileURL)
                self.player.delegate = self
                self.player.play()
            }
            catch { print("⛔️ Erreur lors de la lecture du son") }
        }
    }

    
    //MARK: Actions
    
    
    @IBAction func PointageEmp(_ sender: Any) {
        
        mediaPlayer(son: "sound_on")
        performSegue(withIdentifier: "goToPointEmp", sender: self)
    }
    

    

}
