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
	
	@IBOutlet weak var falseAnswerField: UITextField!
	@IBOutlet weak var trueAnswerField: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		ref = Database.database().reference()
		share()
		questionTextView.delegate = self
		questionTextView.text = "כתוב שאלה"
		questionTextView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
		
		
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.questionTextView.becomeFirstResponder()
        
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
		if trueAnswerField.text == "" && falseAnswerField.text == "" {
			postRef.child("trueAnswer").setValue("כן")
			postRef.child("falseAnswer").setValue("לא")
		} else if trueAnswerField.text == "" && falseAnswerField.text != "" {
			postRef.child("trueAnswer").setValue("כן")
			postRef.child("falseAnswer").setValue(falseAnswerField.text ?? "לא")
		} else {
			postRef.child("trueAnswer").setValue(trueAnswerField.text ?? "כן")
			postRef.child("falseAnswer").setValue(falseAnswerField.text ?? "לא")
		}
		postRef.child("timestamp").setValue(time)
		ref.child(userID!).child("Posts").child(String(time)).setValue(String(time))
        // share() release later...
        performSegue(withIdentifier: "toMain", sender: self)
	}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        questionTextView.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	// for students same school
	
    func share(){
		let schoolName = UserDefaults.standard.string(forKey: "schoolName")
		let firstActivityItem = "פרסמתי הרגע שאלה לכל תלמידי \(schoolName ?? "שם בית ספר"), כנס ותראה!"
        let secondActivityItem : NSURL = NSURL(string: "http://google.com/")! // app url
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)

        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        self.present(activityViewController, animated: true, completion: nil)
    }
	
	
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
