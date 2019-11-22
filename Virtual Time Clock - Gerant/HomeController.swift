//
//  loginToHome.swift
//  Virtual Time Clock - Gerant
//
//  Created by Guillaume Nirlo on 10/31/19.
//  Copyright © 2019 Guillaume Nirlo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI
import AVFoundation



class HomeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate{
    
    // MARK: Outlet
    
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var capture: UIButton!
    @IBOutlet weak var mail: UILabel!
    
    // MARK: Attributs
    
    var player: AVAudioPlayer!
    
     let buttonIcon = UIImage(named: "ic_logout")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            print("✅ Un utilisateur est déjà connecté : \(user.email ?? "")")
            mail.text = user.email
            
        } else {
            fatalError("ℹ️ Aucun utilisateur n'est connecté.")
        }
        
        setup()
        
        //Lien avec l'espace de stockage du serveur Firebase
        let storage = Storage.storage()
        //Creation de la reference de l'image (chemin d'acces)
        let imagesRef = storage.reference().child("Photos/profilePic")
        
        //création des metadata avec le type de la ressource
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        
        imagesRef.getMetadata { (metaData, error) in
            self.img.sd_setImage(with: imagesRef)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = //UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(logOut))
            UIBarButtonItem(image: buttonIcon, style: UIBarButtonItem.Style.done, target: self, action: #selector(logOut))
        //self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 216, green: 78, blue:33,  alpha: 1)
    }
    
    @objc func logOut(){
        //Auth.auth().signOut()
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goBackLoginHome", sender: self)
        } catch let signOutError as NSError {
            print ("⛔️ Erreur de déconnexion : \(signOutError)")
        }
    }
    
    private func setup(){
        capture.layer.cornerRadius = 20
        img.layer.borderWidth = 1
        //let color = UIColor(rgb: 0xD84E21)
        img.layer.borderColor = UIColor.orange.cgColor
        
    }
    
    private func mediaPlayer(son: String) {
        // On va jouer le son
        if let soundFilePath = Bundle.main.path(forResource: son, ofType: "mp3") {
            let fileURL = URL(fileURLWithPath: soundFilePath)
            do {
                try self.player = AVAudioPlayer(contentsOf: fileURL)
                self.player.delegate = self
                self.player.play()
            }
            catch { print("⛔️ Erreur lors de la lecture du son") }
        }
    }
    
    // MARK: Action
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func captureAndSave(_ sender: Any) {
        
        // On va jouer le son
        if let soundFilePath = Bundle.main.path(forResource: "sound_on", ofType: "mp3") {
            let fileURL = URL(fileURLWithPath: soundFilePath)
            do {
                try self.player = AVAudioPlayer(contentsOf: fileURL)
                self.player.delegate = self
                self.player.play()
            }
            catch { print("⛔️ Erreur lors de la lecture du son") }
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                self.mediaPlayer(son: "sound_on")
                
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //let image = info[UIImagePickerController.InfoKey.cropRect] as! UIImage
        
        if let image = info[.editedImage] as? UIImage {
            img.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            img.image = image
        }
        
        
        
        
        //Lien avec l'espace de stockage du serveur Firebase
        let storage = Storage.storage()
        //Creation de la reference de l'image (chemin d'acces)
        let imagesRef = storage.reference().child("Photos/profilePic")
        
        //création des metadata avec le type de la ressource
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        
        
        //mise en memoire sous forme de data
        if let uploadData = self.img.image!.jpegData(compressionQuality: 0.75) {
        
            //upload l'image sur la base
            imagesRef.putData(uploadData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("error")
                    
                } else {
                    print("Image Upload sur le serveur")
                    // On va jouer le son
                    if let soundFilePath = Bundle.main.path(forResource: "sound_on", ofType: "mp3") {
                        let fileURL = URL(fileURLWithPath: soundFilePath)
                        do {
                            try self.player = AVAudioPlayer(contentsOf: fileURL)
                            self.player.delegate = self
                            self.player.play()
                        }
                        catch { print("⛔️ Erreur lors de la lecture du son") }
                    }
                    
                }
           }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    }
    
}

