//
//  ViewController.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 10/21/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: Outlet

    
    @IBOutlet weak var mdpTF: UITextField!
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var conectTF: UIButton!
    
    // MARK: Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    // MARK: Private functions
    
    private func setupButton(){
        conectTF.layer.cornerRadius = 20
    }
    
    // MARK: Action
    
    

}

