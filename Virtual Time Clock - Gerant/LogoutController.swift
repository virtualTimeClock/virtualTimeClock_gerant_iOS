//
//  LogoutController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 11/6/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit

class LogoutController: UIViewController {
    
    // MARK: Outlets
    
    
    @IBOutlet var logoutOT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Mi connai pa quoi faire pour la suite", message:
            "lmavai pa fai rien en 1 mois par ex ma croiser une seule fois mai mi t connai pa elle a lepoque cetai un test ", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "hasard pren tro le temps", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
}
