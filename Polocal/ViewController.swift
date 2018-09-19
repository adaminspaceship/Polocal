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
		
		//Modify shadows alpha
		self.schoolSearchBar.shadowView_alpha = 0.8
		
		//Modify the default icon of suggestionsView's rows
		self.schoolSearchBar.searchImage = UIImage(named: "school")
		//Modify properties of the searchLabel
		self.schoolSearchBar.searchLabel_font = UIFont(name: "almoni-neue-aaa-300.ttf", size: 30)
		self.schoolSearchBar.searchLabel_textColor = UIColor(red:0.00, green:0.77, blue:0.80, alpha:1.0)
		self.schoolSearchBar.searchLabel_backgroundColor = UIColor.white
		self.schoolSearchBar.setTextColor(color: UIColor(red:0.00, green:0.77, blue:0.80, alpha:1.0))
		self.schoolSearchBar.suggestionsView_searchIcon_isRound = false
		
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
		if let path = Bundle.main.path(forResource: "data", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
				let jsonObj = try JSON(data: data)
				for i in 0...707{
					let schoolName = jsonObj[i]["name"].stringValue
					if schoolName == selectedSchool {
						ref.child(uuid).child("school").setValue(jsonObj[i]["semel"].stringValue)
						userDefaults.set(jsonObj[i]["semel"].stringValue, forKey: "schoolSemel")
					}
				}
			} catch let error {
				print("parse error: \(error.localizedDescription)")
			}
		} else {
			print("Invalid filename/path.")
		}
		
        userDefaults.set(uuid, forKey: "userID")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	var selectedSchool = String()
	
	func onClickItemSuggestionsView(item: String) {
		print("User touched this item: "+item)
		self.schoolSearchBar.searchBarTextDidEndEditing(self.schoolSearchBar)
		self.schoolSearchBar.text = item
		selectedSchool = item
	}



}

public extension ModernSearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
}

