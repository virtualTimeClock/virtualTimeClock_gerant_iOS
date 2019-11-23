//
//  ListEmployeesController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/6/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

class ListEmployeesController: UITableViewController, AVAudioPlayerDelegate {
    
    // MARK: Attributs
    let db = Firestore.firestore()
    var users: [Users] = []
    var player: AVAudioPlayer!
    
    // MARK: Cycle de vie

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser == nil {
            fatalError("⛔️ Aucun utilisateur n'est connecté !")
        } else { // Sinon, on affiche les missions
            loadUsersFromDB(dataBase: db)
        }
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateMission))
            mediaPlayer(son: "sound_on")
        
    }
    
    @objc func goToCreateMission(){
        performSegue(withIdentifier: "goToAddEmployees", sender: self)
    }

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
        
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            
            let utilisateur = self.users[indexPath.row].id
            
            self.users.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.db.collection("utilisateurs").document(utilisateur).delete() { err in
                if let err = err {
                    print("Error removing users: \(err)")
                } else {
                    print("Users successfully remove in DB")
                }
                
                let user = Auth.auth().currentUser;
                user?.delete { error in
                  if let error = error {
                    print("Error removing users: \(error)")
                  } else {
                    print("Users successfully remove in Auth")
                  }
                }
                
            }
            
            action.backgroundColor = .red
            
            completion(true)
        }
        
        
        return action
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Création de notre cellule personnalisée
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell") as! CellUsers
        
        
        // Récupération de la mission courante dans la liste
        let user = users[indexPath.row]
        
        // On rempli les différents champs de notre cellule avec la mission courante
        cell.populate(users: user)
        
        return cell
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
    
    private func setup(){
        
        tableView.layer.borderColor = UIColor.darkText.cgColor
        tableView.layer.borderWidth = 10.0
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.layoutMargins.left = 20
        
        
    }
    
    private func loadUsersFromDB(dataBase: Firestore){
        
        self.users = []
        
        dataBase.collection("utilisateurs").getDocuments() { (query, err) in
            if let err = err {
                print("⛔️ Erreur : Impossible d'obtenir les utilisateurs ! \(err)")
            } else {
                print("✅ Document récupéré !")
                for document in query!.documents {
                    
                    // Pour chaque document, on crée une mission et on l'ajoute à la liste
                    
                    //Récupération des String
                    let id: String = document.documentID
                    let nom: String = document.get("nom") as! String
                    let prenom: String = document.get("prenom") as! String
                    
                    
                    // Récupération des dates
                    let dateN_timestamp: Timestamp = document.get("dateNaissance") as! Timestamp
                    let dateNaissance: Date = dateN_timestamp.dateValue()
                    
                    
        
                    
                    // Création de la mission et ajout dans la liste
                    self.users.append( Users(id: id, nom: nom, prenom: prenom, dateNaissance: dateNaissance) )
                }
                
                self.tableView.reloadData() // Rechargmement des données des cellules
                print("✅ Les utilisateurs sont correctement affichées !")
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
