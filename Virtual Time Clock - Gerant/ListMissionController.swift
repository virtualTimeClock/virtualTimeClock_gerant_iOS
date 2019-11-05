//
//  ListMissionController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/4/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ListMissionController: UITableViewController {
    
    // MARK: Attributs
    let db = Firestore.firestore()
    var missions: [Mission] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si aucun utilisateur est connecté, on crash l'application
        if Auth.auth().currentUser == nil {
            fatalError("⛔️ Aucun utilisateur n'est connecté !")
        } else { // Sinon, on affiche les missions
            loadMissionsFromDB(dataBase: db)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return missions.count
    }
    
    // MARK: Private functions
    
    private func loadMissionsFromDB(dataBase: Firestore){
        // Lecture des documents dans la collection "missions"
        dataBase.collection("missions").getDocuments() { (query, err) in
            if let err = err {
                print("⛔️ Erreur : Impossible d'obtenir les missions ! \(err)")
            } else {
                print("✅ Document récupéré !")
                for document in query!.documents {
                    
                    // Pour chaque document, on crée une mission et on l'ajoute à la liste
                    
                    //Récupération des String
                    let id: String = document.documentID
                    let titre: String = document.get("titre") as! String
                    let description: String = document.get("description") as! String
                    let lieu: String = document.get("lieu") as! String
                    
                    // Récupération des dates
                    let debut_timestamp: Timestamp = document.get("debut") as! Timestamp
                    let debut: Date = debut_timestamp.dateValue()
                    let fin_timestamp: Timestamp = document.get("fin") as! Timestamp
                    let fin: Date = fin_timestamp.dateValue()
                    
                    // Récupération des positions (géolocalisation)
                    let localisation: GeoPoint = document.get("localisation") as! GeoPoint
                    let latitude = localisation.latitude
                    let longitude = localisation.longitude
                    
                    // Récupération de Number (rayon)
                    let rayon: Double = document.get("rayon") as! Double
                    
                    
                    // Création de la mission et ajout dans la liste
                    self.missions.append( Mission(id: id, titre: titre, lieu: lieu, description: description, debut: debut, fin: fin, latitude: latitude, longitude: longitude, rayon: rayon) )
                    
                }
                
                self.tableView.reloadData() // Rechargmement des données des cellules
                print("✅ Les missions sont correctement affichées !")
            }
        }
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Création de notre cellule personnalisée
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell") as! CellMission
        
        // Récupération de la mission courante dans la liste
        let mission = missions[indexPath.row]
        
        // On rempli les différents champs de notre cellule avec la mission courante
        cell.populate(mission: mission)
        

        return cell
    }
    

    // MARK: - Navigation
    
    //Clique sur une cellule
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // On désélectionne la cellule cliquée
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Récupération de la mission correspondant à la cellule cliquée
        let mission = missions[indexPath.row]
        
        performSegue(withIdentifier: "goToDetailsMission", sender: mission)
    }
    

    // Fontion permettant de faire des actions avant l'envoi du segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // On test si le segue est bien celui qu'on espère
        if segue.identifier == "goToDetailsMission" {
            
            // Récupération de la destination du segue
            let destination = segue.destination as! MissionDetailController
            
            let mission = sender as! Mission
            destination.mission = mission
            
        }
    }
}
