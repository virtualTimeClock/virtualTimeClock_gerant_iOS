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

class AddEmployeesController: UIViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var bornTF: UITextField!
    @IBOutlet weak var confirmTF: UIButton!
    @IBOutlet weak var cancelTF: UIButton!
    
    // MARK: Attribut

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()

        
    }
    
    // MARK: Private functions
    
    private func setupTextField(){
        //Liaison avec les délégués
        nameTF.delegate = self
        firstnameTF.delegate = self
        bornTF.delegate = self
        
        // Personnalisation des placeholders
            nameTF.attributedPlaceholder = NSAttributedString(string:"Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            firstnameTF.attributedPlaceholder = NSAttributedString(string:"FirstName", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            bornTF.attributedPlaceholder = NSAttributedString(string:"Birthday", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //Tap gesture pour fermer le clavier quand on clique dans le vide
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    
    @objc private func hideKeyboard(){
        nameTF.resignFirstResponder()
        firstnameTF.resignFirstResponder()
        bornTF.resignFirstResponder()
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        performSegue(withIdentifier: "EmpToHome", sender: self)
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let userDoc = db.collection("utilisateurs")
        
        userDoc.document().setData([
            "dateNaissance": bornTF.text ?? "???",
            "isLeader": false,
            "nom": nameTF.text ?? "???",
            "prenom": firstnameTF.text ?? "???",
        ])
        
        performSegue(withIdentifier: "goToPwd", sender: self)

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
