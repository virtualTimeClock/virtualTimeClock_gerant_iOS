//
//  CellPointEmp.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/22/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit

class CellPointEmp: UITableViewCell {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var prenom: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(pointEmp: PointEmp) {
        name.text = pointEmp.nom
        prenom.text = pointEmp.prenom
        date.text = pointEmp.date
        
        //img.image = pointEmp.estPresent ? UIImage(named: "ic_in_zone") : UIImage(named: "ic_out_zone")
        img.image = UIImage(named: pointEmp.estPresent ? "ic_in_zone": "ic_out_zone")
    }

}
