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
    @IBOutlet weak var date: UILabel!
    
    // MARK: Cycle de vie
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Changement des marges des cellules, de la bordure et du fond
        let padding = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: padding)
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.backgroundColor = UIColor.orange.cgColor
        
    }
    
    // Fonction qui va extraire les informations nécessaires dans une instance de Users donnée en paramètre
    func populate(users: Users) {
        nom.text = users.nom
        prenom.text = users.prenom
        date.text = users.dateNaissance
        
    }

}
