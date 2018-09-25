//
//  AddPostViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 19/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddPostViewController: UIViewController, UITextViewDelegate {

	@IBOutlet weak var questionTextView: UITextView!
	var ref: DatabaseReference!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		ref = Database.database().reference()
		
		questionTextView.delegate = self
		questionTextView.text = "כתוב שאלה"
		questionTextView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func doneButtonTapped(_ sender: Any) {
		let userDefaults = UserDefaults.standard
		let userID = userDefaults.string(forKey: "userID")
		let uuid = UUID().uuidString
		let time = Int(Date().timeIntervalSince1970)
		let postRef = ref.child("Posts").child(userDefaults.string(forKey: "schoolSemel")!).child(String(time))
		postRef.child("usersRead").child("userID").setValue("0")
		postRef.child("answers").child("false").setValue(0)
		postRef.child("answers").child("true").setValue(0)
		postRef.child("question").setValue(questionTextView.text ?? "nil") // if nil alert the user
		postRef.child("timestamp").setValue(time)
		ref.child(userID!).child("Posts").childByAutoId().setValue(String(time))
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	
	
	
	func textViewDidBeginEditing(_ questionTextView: UITextView) {
		if questionTextView.textColor == UIColor.lightGray {
			questionTextView.text = nil
			questionTextView.textColor = UIColor(red:0.00, green:0.77, blue:0.80, alpha:1.0)
		}
	}
	func textViewDidEndEditing(_ questionTextView: UITextView) {
		if questionTextView.text.isEmpty {
			questionTextView.text = "כתוב שאלה"
			questionTextView.textColor = UIColor.lightGray
		}
	}

}
