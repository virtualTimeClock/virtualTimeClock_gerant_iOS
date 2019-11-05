//
//  CellMission.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/4/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit

class CellMission: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var lieu: UILabel!
    
    
    @IBOutlet weak var dateH: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    // Fonction qui va extraire les informations nécessaires dans une instance de Mission donnée en paramètre
    func populate(mission: Mission) {
        title.text = mission.titre
        desc.text = mission.description
        
        lieu.text = mission.lieu
    }

}
