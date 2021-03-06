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
	@IBOutlet weak var startButton: UIButton!
	
	@IBOutlet weak var schoolSearchBar: ModernSearchBar!
	
	func isKeyPresentInUserDefaults(key: String) -> Bool {
		return UserDefaults.standard.object(forKey: key) != nil
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if isKeyPresentInUserDefaults(key: "userID") {
			performSegue(withIdentifier: "toMain", sender: self)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		let greyColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:0.8)
		startButton.setBackgroundColor(color: greyColor, forState: .highlighted)
		// Do any additional setup after loading the view, typically from a nib.
		ref = Database.database().reference()
		self.schoolSearchBar.delegateModernSearchBar = self
		//        schoolTextField.layer.cornerRadius = 15.0
		var suggestionList = Array<String>()
		
		//Modify shadows alpha
		self.schoolSearchBar.shadowView_alpha = 0.8
		
		//Modify the default icon of suggestionsView's rows
		self.schoolSearchBar.searchImage = UIImage(named: "school")
		self.schoolSearchBar.shadowView_alpha = 0.0
		self.schoolSearchBar.suggestionsView_separatorStyle = .none
		//Modify properties of the searchLabel
		self.schoolSearchBar.searchLabel_font = UIFont(name: "almoni-neue-aaa-300.ttf", size: 30)
		self.schoolSearchBar.searchLabel_textColor = UIColor(red:0.00, green:0.77, blue:0.80, alpha:1.0)
		self.schoolSearchBar.searchLabel_backgroundColor = UIColor.white
		self.schoolSearchBar.setTextColor(color: .white)
		self.schoolSearchBar.suggestionsView_searchIcon_isRound = false
		
		if let path = Bundle.main.path(forResource: "data", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
				let jsonObj = try JSON(data: data)
				for (key,value) in jsonObj {
					let schoolName = value.stringValue
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
		if self.schoolSearchBar.text == "" {
			self.shake(view: self.startButton)
		} else {
			if let path = Bundle.main.path(forResource: "data", ofType: "json") {
				do {
					let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
					let jsonObj = try JSON(data: data)
					for (key,value) in jsonObj {
						let schoolName = value.stringValue
						if schoolName == selectedSchool {
							ref.child(uuid).child("school").setValue(key)
							userDefaults.set(key, forKey: "schoolSemel")
							userDefaults.set(uuid, forKey: "userID")
							performSegue(withIdentifier: "toMain", sender: self)
						} else {
							//self.shake(view: self.startButton)
						}
					}
					
				} catch let error {
					print("parse error: \(error.localizedDescription)")
				}
			} else {
				print("Invalid filename/path.")
			}
			
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func shake(view: UIView, for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
		let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
			view.transform = CGAffineTransform(translationX: translation, y: 0)
		}
		
		propertyAnimator.addAnimations({
			view.transform = CGAffineTransform(translationX: 0, y: 0)
		}, delayFactor: 0.2)
		
		propertyAnimator.startAnimation()
	}
	
	var selectedSchool = String()
	
	func onClickItemSuggestionsView(item: String) {
		print("User touched this item: "+item)
		self.schoolSearchBar.searchBarTextDidEndEditing(self.schoolSearchBar)
		UserDefaults.standard.set(item, forKey: "schoolName")
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






