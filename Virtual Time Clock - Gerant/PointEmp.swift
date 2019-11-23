//
//  PointEmp.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/22/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import Foundation

class PointEmp {
    
    // MARK: Attributs
    let id: String
    let nom: String
    let prenom: String
    let date: String
    let estPresent: Bool

    
    
    
    init(id: String, nom: String, prenom: String, date: Date, estPresent: Bool) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.estPresent = estPresent
        
        let dn:Date = date
        let dat = DateFormatter()
        dat.dateStyle = .short
        dat.timeStyle = .short
        let dateU = dat.string(from: dn)
        
        self.date = dateU
        
    }
    
    
}
