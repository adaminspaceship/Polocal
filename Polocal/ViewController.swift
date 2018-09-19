//
//  ViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 18/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet var schoolTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
//        schoolTextField.layer.cornerRadius = 15.0
        
        
        
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let uuid = UUID().uuidString
        ref.child(uuid).child("school").setValue(schoolTextField.text ?? "blich")
        userDefaults.set(uuid, forKey: "userID")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

