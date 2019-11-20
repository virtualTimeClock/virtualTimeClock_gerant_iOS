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

class AddEmployeesController: UIViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var bornTF: UITextField!
    @IBOutlet weak var confirmTF: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    
    // MARK: Attribut
    
    private var datePicker: UIDatePicker?

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
                }
            }
        } else {
            print("Un des champs n'est pas rempli correctement")
        }
        
        self.view.makeToast("Le compte a été crée")

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
