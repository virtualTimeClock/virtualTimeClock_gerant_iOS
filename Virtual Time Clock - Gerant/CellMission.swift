//
//  CellMission.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/4/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit

class CellMission: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lieu: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    // MARK: Cycle de vie
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Changement des marges des cellules, de la bordure et du fond
        let padding = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: padding)
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.backgroundColor = UIColor.orange.cgColor
    }
    
    
    // Fonction qui va extraire les informations nécessaires dans une instance de Mission donnée en paramètre
    func populate(mission: Mission) {
        title.text = mission.titre
        desc.text = mission.description
        lieu.text = mission.lieu
        
        // Récupération des dates
        let debDB:Date = mission.debut
        let dat = DateFormatter()
        dat.dateStyle = .short
        dat.timeStyle = .short
        let debutST = dat.string(from: debDB)
        date.text = debutST
        
        
    }

}
