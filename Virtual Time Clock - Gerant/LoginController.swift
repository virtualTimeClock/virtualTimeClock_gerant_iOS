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
import AVFoundation
import Toast_Swift

class LoginController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: Outlet

    
    @IBOutlet weak var mdpTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var conectTF: UIButton!
    
    //MARK: Attributs
    
    var player: AVAudioPlayer!
    
    // MARK: Cycle de vie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupTextField()
        
        // On va tester si un gérant est déjà connecté. Si c'est le cas, on le redirige vers la liste des missions.
        if let user = Auth.auth().currentUser {
            print("✅ Un gérant est déjà connecté : \(user.email ?? "")")
            perform(#selector(loginagain), with: nil, afterDelay: 0)
            // Ici, on utilise un sélector pour s'assurer que la vue vers laquelle on veut rediriger le gérannt soit belle et bien chargée.
        } else {
            print("ℹ️ Aucun gérant n'est connecté.")
        }
        
    }
    
    @objc private func loginagain() {
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
    
    //Fonction appelée par le TapGesture : permet de fermer le clavier
    @objc private func hideKeyboard(){
        mailTF.resignFirstResponder()
        mdpTF.resignFirstResponder()
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
    
    private func setupButton(){
        conectTF.layer.cornerRadius = 20
        
    }
    
    private func setupTextField(){
        //Liaison avec les délégués
        mailTF.delegate = self
        mdpTF.delegate = self
        
        // Personnalisation des placeholders
        mailTF.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("emailPlaceholder", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
               mdpTF.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("passwordPlaceholder", comment: "Labels"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //Tap gesture pour fermer le clavier quand on clique dans le vide
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    
    @IBAction func onClickLogInButton(_ sender: UIButton) {
        
        if mailTF.text != "" && mdpTF.text != "" {
                   Auth.auth().signIn(withEmail: mailTF.text!, password: mdpTF.text!) { (AuthentificationResult, error) in
                       if((error) != nil) { // Erreur d'authentification
                           print("⛔️ Erreur lors de la connexion de l'utilisateur : " + error.debugDescription)
                       }
                       else { // Authentification réussie
                           print("✅ Connexion de l'utilisateur " + self.mailTF.text!)
                        self.view.makeToast(NSLocalizedString("connect", comment: "Labels"))
                           
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
                                    self.mediaPlayer(son: "sound_on")
                                    
                                       self.performSegue(withIdentifier: "loginToHome", sender: self)
                                   }
                                   else { // Ce n'est pas un gérant, c'est un employé !
                                       print("⛔️ C'est un employé, je le déconnecte")
                                        self.view.makeToast(NSLocalizedString("errorCo", comment: "Labels"))
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
                                    // On va jouer le son
                                    self.mediaPlayer(son: "error_sound")
                               }
                           }
                       }
                   }
               }
               else { // Les champs ne sont pas remplis
                   print("⛔️ Veuillez remplir les champs !")
                   self.view.makeToast(NSLocalizedString("champ", comment: "Labels"))
                   mediaPlayer(son: "error_sound")
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
