//
//  ViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 18/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import ModernSearchBar

class ViewController: UIViewController, ModernSearchBarDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet var schoolTextField: UITextField!
	@IBOutlet weak var schoolSearchBar: ModernSearchBar!
	

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
		self.schoolSearchBar.delegateModernSearchBar = self
//        schoolTextField.layer.cornerRadius = 15.0
		var suggestionList = Array<String>()
		
		
		
		
		if let path = Bundle.main.path(forResource: "data", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
				let jsonObj = try JSON(data: data)
				for i in 0...707{
					let schoolName = jsonObj[i]["name"].stringValue
					suggestionList.append(schoolName)
				}
				self.schoolSearchBar.setDatas(datas: suggestionList)
			} catch let error {
				print("parse error: \(error.localizedDescription)")
			}
		} else {
			print("Invalid filename/path.")
		}
        
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
	
	func onClickItemSuggestionsView(item: String) {
		print("User touched this item: "+item)
	}



}

