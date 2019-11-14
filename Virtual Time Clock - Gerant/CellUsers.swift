//
//  CellUsers.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/6/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit

class CellUsers: UITableViewCell {
    
    // MARK: Outlets
    
    
    @IBOutlet weak var nom: UILabel!
    
    @IBOutlet weak var prenom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Fonction qui va extraire les informations nécessaires dans une instance de Users donnée en paramètre
    func populate(users: Users) {
        nom.text = users.nom
        prenom.text = users.prenom
        
    }

}
