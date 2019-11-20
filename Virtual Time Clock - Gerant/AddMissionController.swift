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

class AddMissionController: UIViewController {
    
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
    
    private func setupTextField(){
        //Liaison avec les délégués
        titleTF.delegate = self
        dateStartTF.delegate = self
        dateEndTF.delegate = self
        latitudeTF.delegate = self
        longitudeTF.delegate = self
        rayonTF.delegate = self
        lieuTF.delegate = self
        descTF.delegate = self
        
        // Personnalisation des placeholders
            titleTF.attributedPlaceholder = NSAttributedString(string:"Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            dateStartTF.attributedPlaceholder = NSAttributedString(string:"Date start", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            dateEndTF.attributedPlaceholder = NSAttributedString(string:"Date end", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            latitudeTF.attributedPlaceholder = NSAttributedString(string:"Latitude", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            longitudeTF.attributedPlaceholder = NSAttributedString(string:"Longitude", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            rayonTF.attributedPlaceholder = NSAttributedString(string:"Rayon", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            lieuTF.attributedPlaceholder = NSAttributedString(string:"Lieu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            descTF.attributedPlaceholder = NSAttributedString(string:"Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //Tap gesture pour fermer le clavier quand on clique dans le vide
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: Action
    
    @objc private func hideKeyboard(){
        titleTF.resignFirstResponder()
        dateStartTF.resignFirstResponder()
        dateEndTF.resignFirstResponder()
        latitudeTF.resignFirstResponder()
        longitudeTF.resignFirstResponder()
        rayonTF.resignFirstResponder()
        lieuTF.resignFirstResponder()
        descTF.resignFirstResponder()
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let userDoc = db.collection("missions")
        
        /*
        let dateCourante: Timestamp = Timestamp(date: Date())
        let dateCourante2: Timestamp = Timestamp(date: Date())*/
        let dateCourante: Timestamp = Timestamp(date: datePicker!.date);
        
        let dateCourante2: Timestamp = Timestamp(date: datePicker2!.date);
        
        
        let getLatText: String = ""+latitudeTF.text!
        let latConvertDouble = Double(getLatText)
        let lat : Double = Double(latConvertDouble!)
        
        let getLongText: String = ""+longitudeTF.text!
        let longConvertDouble = Double(getLongText)
        let long : Double = Double(longConvertDouble!)
        
        
        let pos: GeoPoint = GeoPoint(latitude: lat, longitude: long)
        
        
        
        /*Timestamp().dateValue()*/
        
        /*DateFormatter*/
        
        userDoc.document().setData([
            "debut": dateCourante,
            "description": descTF.text!,
            "fin": dateCourante2,
            "lieu": lieuTF.text ?? "",
            "localisation": pos,
            "rayon": rayonTF.text ?? "",
            "titre": titleTF.text ?? "",
            
        ])
        
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

