//
//  Mission.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/4/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import Foundation

class Mission {
    
    // MARK: Attributs
    let id: String
    let titre: String
    let description: String
    let lieu: String
    let debut: Date
    let fin: Date
    let latitude: Double
    let longitude: Double
    let rayon: Double
    
    init(id: String, titre: String, lieu: String, description: String, debut: Date, fin: Date, latitude: Double, longitude: Double, rayon: Double) {
        self.id = id
        self.titre = titre
        self.lieu = lieu
        self.description = description
        self.debut = debut
        self.fin = fin
        self.latitude = latitude
        self.longitude = longitude
        self.rayon = rayon
    }
    
}
