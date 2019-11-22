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

class ListEmployeesController: UITableViewController {
    
    // MARK: Attributs
    let db = Firestore.firestore()
    var users: [Users] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser == nil {
            fatalError("⛔️ Aucun utilisateur n'est connecté !")
        } else { // Sinon, on affiche les missions
            loadUsersFromDB(dataBase: db)
        }
        
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateMission))
        
        
    }
    
    @objc func goToCreateMission(){
        performSegue(withIdentifier: "goToAddEmployees", sender: self)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    // MARK: Private functions
    
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Création de notre cellule personnalisée
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell") as! CellUsers
        
        // Récupération de la mission courante dans la liste
        let user = users[indexPath.row]
        
        // On rempli les différents champs de notre cellule avec la mission courante
        cell.populate(users: user)
        

        return cell
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
