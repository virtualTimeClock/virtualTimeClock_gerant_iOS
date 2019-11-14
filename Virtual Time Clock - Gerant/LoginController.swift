//
//  ViewController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 10/21/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginController: UIViewController {
    
    // MARK: Outlet

    
    @IBOutlet weak var mdpTF: UITextField!
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var conectTF: UIButton!
    
    // MARK: Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupTextField()
        
        /*
        if let user = Auth.auth().currentUser {
            
        }*/
        
        
        
    }
    
    // MARK: Private functions
    
    private func setupButton(){
        conectTF.layer.cornerRadius = 20
        
    }
    
    private func setupTextField(){
        //Liaison avec les délégués
        mailTF.delegate = self
        mdpTF.delegate = self
        
        // Personnalisation des placeholders
               mailTF.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
               mdpTF.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //Tap gesture pour fermer le clavier quand on clique dans le vide
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    
    //Fonction appelée par le TapGesture : permet de fermer le clavier
    @objc private func hideKeyboard(){
        mailTF.resignFirstResponder()
        mdpTF.resignFirstResponder()
    }
    
    @IBAction func onClickLogInButton(_ sender: UIButton) {
        
        if mailTF.text != "" && mdpTF.text != "" {
                   Auth.auth().signIn(withEmail: mailTF.text!, password: mdpTF.text!) { (AuthentificationResult, error) in
                       if((error) != nil) { // Erreur d'authentification
                           print("⛔️ Erreur lors de la connexion de l'utilisateur : " + error.debugDescription)
                       }
                       else { // Authentification réussie
                           print("✅ Connexion de l'utilisateur " + self.mailTF.text!)
                           
                           // On va vérifier que c'est bien un gérant
                           let db = Firestore.firestore()          // Instance de la base de données
                           let user = Auth.auth().currentUser      // Récupération de l'utilisateur courrant
                           let userId = user?.uid                  // Id de l'utilisateur courrant
                           
                           // Récupération des données de cet utilisateur dans la BD
                           let documentCurrentUser = db.collection("utilisateurs").document(userId!)
                           
                           documentCurrentUser.getDocument { (document, error) in
                               // On test si le document lié à cet utilisateur existe bien
                               if let document = document, document.exists {
                                   let isLeader = document.get("isLeader") as! Bool    // Récupération du champ isLeader
                                   if isLeader == true {                              // C'est un gérant
                                       print("✅ C'est un leader, je le redirige vers la liste des missions")
                                       self.performSegue(withIdentifier: "loginToHome", sender: self)
                                   }
                                   else { // Ce n'est pas un gérant, c'est un employé !
                                       print("⛔️ C'est un employé, je le déconnecte")
                                       // Déconnexion de l'utilisateur
                                       do {
                                           try Auth.auth().signOut()
                                       } catch let signOutError as NSError {
                                         print ("⛔️ Erreur de déconnexion : \(signOutError)")
                                       }
                                   }
                               }
                               else {
                                   print("⛔️ Erreur : Le document demandé pour cet utilisateur n'existe pas !")
                               }
                           }
                       }
                   }
               }
               else { // Les champs ne sont pas remplis
                   print("⛔️ Veuillez remplir les champs !")
               }
           }
        
}
    

    
    



// MARK: Extensions
//Délégué des TextField
extension LoginController:UITextFieldDelegate{
    
    //Gestion de l'appui sur le bouton return du clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Permet de fermer le clavier
        return true
    }
}
