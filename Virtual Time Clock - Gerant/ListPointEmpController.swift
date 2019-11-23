//
//  ListPointEmpController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/22/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ListPointEmpController: UITableViewController {
    
    
    
    // MARK: Attributs
    let db = Firestore.firestore()
    var missionID: String = " "
    var pointEmp: [PointEmp] = []
    

    //MARK: Action
    
    @IBAction func refresh(_ sender: Any) {
        
        viewUsersFromMission(dataBase: db)
    }
    
    //MARK: Cycle de vie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser == nil {
            fatalError("⛔️ Aucun utilisateur n'est connecté !")
        } else { // Sinon, on affiche les employés qui ont pointés
            
            viewUsersFromMission(dataBase: db)
            
        }
    }
    
    // MARK: - Table view data source

      override func numberOfSections(in tableView: UITableView) -> Int {
          // #warning Incomplete implementation, return the number of sections
          return 1
      }

      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          // #warning Incomplete implementation, return the number of rows
          
          
          return pointEmp.count
          
      }

      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          // Création de notre cellule personnalisée
          let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell") as! CellPointEmp
          
          // Récupération de la mission courante dans la liste
          let point = pointEmp[indexPath.row]
          
          
          
          // On rempli les différents champs de notre cellule avec la mission courante
          
          cell.populate(pointEmp: point)
          

          return cell
      }
    
    
    //MARK: Private functions
    
    private func viewUsersFromMission(dataBase: Firestore){
        
        self.pointEmp.removeAll()
        db.collection("pointage").document(missionID).collection("pointageMission").getDocuments() { (query, err) in
            if let err = err {
                print("⛔️ Erreur : Impossible d'obtenir les missions ! \(err)")
            } else {
                print("✅ Document récupéré !")
                for document in query!.documents {
                    
                    let userID = document.documentID
                    let estPresent = document.get("estPresent") as! Bool
                    let dateTimestamp = document.get("date") as! Timestamp
                    
                    let date = dateTimestamp.dateValue()
                    var name: String = ""
                    var firstname: String = ""
                    
                    if userID != "" {
                        self.db.collection("utilisateurs").document(userID).getDocument { (document2, error) in
                            if let error = error {
                                print("⛔️ Erreur : Impossible d'obtenir les utilisateurs ! \(error)")
                            } else if let document2 = document2, document2.exists {
                                firstname = document2.get("prenom") as! String
                                name = document2.get("nom") as! String
                                
                                print("\(name)name")
                                print("\(firstname)firstname")
                                self.pointEmp.append(PointEmp(id: userID, nom: name, prenom: firstname, date: date, estPresent: estPresent))
                                self.tableView.reloadData() // Rechargmement des données des cellules
                            } else {
                                print("L'utilisateur n'existe pas")
                                self.db.collection("pointage").document(self.missionID).collection("pointageMission").document(userID).delete()
                            }
                        }
                    }
                    
                }
                print("✅ Les users qui ont pointés sont correctement affichées !")
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
