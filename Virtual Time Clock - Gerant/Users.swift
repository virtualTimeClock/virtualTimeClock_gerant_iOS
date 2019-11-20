//
//  Users.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/6/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import Foundation

class Users {
    
    // MARK: Attributs
    let id: String
    let nom: String
    let prenom: String
    let dateNaissance: String
    
    init(id: String, nom: String, prenom: String, dateNaissance: Date) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        
        let dn:Date = dateNaissance
        let dat = DateFormatter()
        dat.dateStyle = .short
        dat.timeStyle = .short
        let dateB = dat.string(from: dn)
        
        
        self.dateNaissance = dateB
    }
    
    
}
