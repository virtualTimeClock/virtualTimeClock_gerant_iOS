//
//  loginToHome.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 10/31/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var addEmpBT: UIButton!
    @IBOutlet weak var listEmpBT: UIButton!
    @IBOutlet weak var addMissionBT: UIButton!
    @IBOutlet weak var listMission: UIButton!
    
    // MARK: Attributs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: Action
    
    
    @IBAction func addMission(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddMission", sender: self)
    }
    
    
    @IBAction func addEmp(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddEmp", sender: self)
    }
    

    @IBAction func listEmp(_ sender: UIButton) {
        performSegue(withIdentifier: "goToListEmp", sender: self)
    }
    
    
    @IBAction func listMission(_ sender: UIButton) {
        performSegue(withIdentifier: "goToListMission", sender: self)
    }
    
}
