//
//  AddEmployeesController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/2/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Toast_Swift
import AVFoundation
import CoreMotion

class AddEmployeesController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: Outlet
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var bornTF: UITextField!
    @IBOutlet weak var confirmTF: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    
    // MARK: Attribut
    
    private var datePicker: UIDatePicker?
    var player: AVAudioPlayer!
    
    let motionManager = CMMotionManager()   // Manageur de capteurs
    var isMovingPhone: Bool = false         // Vrai quand le téléphone est en mouvement
    var lastTimeCheck:Date?                 // Heure de début du dernier mouvement

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddEmployeesController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        
        bornTF.inputView =  datePicker
        
        
        
    
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // On va écouter les mouvements de l'accélétomètre avec les données pré-traitées
        listenDeviceMovement()
    }
    
    // Appelé quand la vue va disparaître, mais les données sont encore en mémoire.
    override func viewWillDisappear(_ animated: Bool) {
        
        motionManager.stopDeviceMotionUpdates() // On désactive le capteur
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        bornTF.text = dateFormatter.string(from: datePicker .date)
        view.endEditing(true)
    }
    
    // MARK: Private functions
    
    private func setupTextField(){
        //Liaison avec les délégués
        usernameTF.delegate = self
        emailTF.delegate = self
        nameTF.delegate = self
        firstnameTF.delegate = self
        bornTF.delegate = self
        
        // Personnalisation des placeholders
            usernameTF.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            emailTF.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            nameTF.attributedPlaceholder = NSAttributedString(string:"Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            firstnameTF.attributedPlaceholder = NSAttributedString(string:"FirstName", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            bornTF.attributedPlaceholder = NSAttributedString(string:"Birthday", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
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
                            self.usernameTF.text = ""   // On efface le texte
                            self.emailTF.text = ""   // On efface le texte
                            self.nameTF.text = ""   // On efface le texte
                            self.firstnameTF.text = ""   // On efface le texte
                            self.bornTF.text = ""   // On efface le texte
                            
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
    
    private func addUserDB(){
        let db = Firestore.firestore()
        let userDoc = db.collection("utilisateurs")
        
        
        let finaldate: Timestamp = Timestamp(date: datePicker!.date);
        
        
        userDoc.document().setData([
            "dateNaissance": finaldate,
            "isLeader": false,
            "nom": nameTF.text ?? "???",
            "prenom": firstnameTF.text ?? "???",
        ])
        
        
    }
    
    
    // MARK: Actions
    
    @objc private func hideKeyboard(){
        usernameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        firstnameTF.resignFirstResponder()
        bornTF.resignFirstResponder()
    }
    
    
    
    
    @IBAction func confirm(_ sender: UIButton) {
        
        addUserDB()
        
        let len = 8
        let pswdChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let rndPswd = String((0..<len).compactMap{ _ in pswdChars.randomElement() })
        
        if usernameTF.text != "" && emailTF.text != "" {
            Auth.auth().createUser(withEmail: emailTF.text!, password: rndPswd) { (authResult, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Inscription réussie")
                    Auth.auth().sendPasswordReset(withEmail: self.emailTF.text!) { (error) in
                        if error != nil {
                            print(error.debugDescription)
                        } else {
                            print("Send a password reset ")
                        }
                    }
                    
                }
            }
        } else {
            print("Un des champs n'est pas rempli correctement")
        }
        
        self.view.makeToast("Le compte a été crée")
        
        // On va jouer le son
        if let soundFilePath = Bundle.main.path(forResource: "sound_on", ofType: "mp3") {
            let fileURL = URL(fileURLWithPath: soundFilePath)
            do {
                try self.player = AVAudioPlayer(contentsOf: fileURL)
                self.player.delegate = self
                self.player.play()
            }
            catch { print("⛔️ Erreur lors de la lecture du son") }
        }

    }
    
    
    
    

}

// MARK: Extensions
//Délégué des TextField
extension AddEmployeesController:UITextFieldDelegate{
    
    //Gestion de l'appui sur le bouton return du clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Permet de fermer le clavier
        return true
    }
}
