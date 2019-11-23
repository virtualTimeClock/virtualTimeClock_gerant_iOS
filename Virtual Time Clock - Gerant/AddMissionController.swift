//
//  AddMissionController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/2/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Toast_Swift
import CoreLocation
import AVFoundation
import CoreMotion


class AddMissionController: UIViewController, CLLocationManagerDelegate, AVAudioPlayerDelegate {
    
    // MARK: Outlet
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateStartTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var dateEndTF: UITextField!
    @IBOutlet weak var rayonTF: UITextField!
    @IBOutlet weak var lieuTF: UITextField!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var confirmBT: UIButton!
    
    
    
    // MARK: Attributs
    
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?
    
    var player: AVAudioPlayer!
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    let locationManager = CLLocationManager()
    
    let motionManager = CMMotionManager()   // Manageur de capteurs
    var isMovingPhone: Bool = false         // Vrai quand le téléphone est en mouvement
    var lastTimeCheck:Date?                 // Heure de début du dernier mouvement
    
    // MARK: Cycle de vie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddMissionController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        
        dateStartTF.inputView =  datePicker
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        datePicker2?.addTarget(self, action: #selector(dateChanged2(datePicker2:)), for: .valueChanged)
        
        dateEndTF.inputView =  datePicker2
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            
            locationManager.requestAlwaysAuthorization()
            
            locationManager.startUpdatingLocation()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // On va écouter les mouvements de l'accélétomètre avec les données pré-traitées
        listenDeviceMovement()
    }
    
    // Appelé quand la vue va disparaître, mais les données sont encore en mémoire.
    override func viewWillDisappear(_ animated: Bool) {
        
        motionManager.stopDeviceMotionUpdates() // On désactive le capteur
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        latitude = Double(locValue.latitude)
        longitude = Double(locValue.longitude)
        let lat = "\(latitude)"
        let long = "\(longitude)"
        latitudeTF.text = lat
        longitudeTF.text = long
        
    }
    
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateStartTF.text = dateFormatter.string(from: datePicker .date)
        view.endEditing(true)
    }
    
    @objc func dateChanged2(datePicker2 : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateEndTF.text = dateFormatter.string(from: datePicker2 .date)
        view.endEditing(true)
    }
    
    // MARK: Private functions
    
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
    
    private func setupTextField(){
        //Liaison avec les délégués
        titleTF.delegate = self
        latitudeTF.delegate = self
        longitudeTF.delegate = self
        rayonTF.delegate = self
        lieuTF.delegate = self
        descTF.delegate = self
        
        // Personnalisation des placeholders
            titleTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("Title", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            dateStartTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("dateStart", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            dateEndTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("dateEnd", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            latitudeTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("latitude", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            longitudeTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("longitude", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            rayonTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("rayon", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            lieuTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("lieu", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            descTF.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("description", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //Tap gesture pour fermer le clavier quand on clique dans le vide
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    // Fonction qui utilise l'accéléromètre pour détecter une secousse du téléphone et efface le texte du rapport le téléhpone est secoué pendant plus de 0.5 secondes
    private func listenDeviceMovement(){
        // On va utiliser les données pré-traitées de l'accéléromètre
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1 // Interval de prélèvement des valeurs
            motionManager.startDeviceMotionUpdates(to: .main) { (dm, error) in
                if let e = error {
                    print("⛔️ Erreur lors du relevé des valeurs du DeviceMotion : \(e.localizedDescription)")
                } else {
                    let accelerationX = dm?.userAcceleration.x  // Accélération sur l'axe X
                    let accelerationY = dm?.userAcceleration.y  // Accélération sur l'axe Y
                    let accelerationZ = dm?.userAcceleration.z  // Accélération sur l'axe Z
                    let now = Date() // Date actuelle
                    
                    // Si on détecte une secousse
                    if abs(accelerationX!) > 0.5 || abs(accelerationY!) > 0.5 || abs(accelerationZ!) > 0.5 {
                        if !self.isMovingPhone { // Si le téléphone n'est pas en état "moving"
                            self.lastTimeCheck = now    // On lance le chrono, en sauvegardant l'heure actuelle
                            self.isMovingPhone = true   // On indique que le téléphone est dans l'état "moving"
                        } else if now.timeIntervalSince(self.lastTimeCheck!) >= 0.5 {   // Si le téléphone est dans l'état "moving" pendant plus de 0.5 secondes
                            self.titleTF.text = ""   // On efface le texte
                            self.dateStartTF.text = ""   // On efface le texte
                            self.dateEndTF.text = ""   // On efface le texte
                            self.rayonTF.text = ""   // On efface le texte
                            self.lieuTF.text = ""   // On efface le texte
                            self.descTF.text = ""   // On efface le texte
                            self.isMovingPhone = false      // On indique que le téléphone n'est plus dans l'état "moving"
                        }
                    } else {
                        // Si le téléphone ne bouge plus on indique qu'il n'est plus dans l'état "moving"
                        self.isMovingPhone = false
                    }
                }
            }
        }
    }
    
    
    // MARK: Action
    
    @objc private func hideKeyboard(){
        titleTF.resignFirstResponder()
        latitudeTF.resignFirstResponder()
        longitudeTF.resignFirstResponder()
        rayonTF.resignFirstResponder()
        lieuTF.resignFirstResponder()
        descTF.resignFirstResponder()
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let userDoc = db.collection("missions")
        let dateCourante: Timestamp = Timestamp(date: datePicker!.date);
        let dateCourante2: Timestamp = Timestamp(date: datePicker2!.date);
        let getrayon: String = ""+rayonTF.text!
        let rayonConvertDouble = Double(getrayon)
        let rayonFinal: Double = Double(rayonConvertDouble!)
        let pos: GeoPoint = GeoPoint(latitude: latitude, longitude: longitude )
        
        userDoc.document().setData([
            "debut": dateCourante,
            "description": descTF.text!,
            "fin": dateCourante2,
            "lieu": lieuTF.text ?? "",
            "localisation": pos,
            "rayon": rayonFinal,
            "titre": titleTF.text ?? "",
        ])
        
        mediaPlayer(son: "sound_on")
        
        self.view.makeToast(NSLocalizedString("succesMission", comment: "Labels"))
        
    }
    
}

// MARK: Extensions
//Délégué des TextField
extension AddMissionController:UITextFieldDelegate{
    
    //Gestion de l'appui sur le bouton return du clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Permet de fermer le clavier
        return true
    }
}

