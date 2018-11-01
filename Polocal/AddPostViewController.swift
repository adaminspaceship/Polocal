//
//  AddPostViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 19/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Malert

class AddPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

	@IBOutlet weak var questionTextView: UITextView!
	var ref: DatabaseReference!
	
	@IBOutlet weak var addPostButton: UIButton!
	@IBOutlet weak var maxCharLimit: UILabel!
	@IBOutlet weak var questionView: UIView!
	@IBOutlet weak var falseAnswerField: UITextField!
	@IBOutlet weak var trueAnswerField: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		addPostButton.setBackgroundColor(color: .lightGray, forState: .highlighted)
		addPostButton.setTitleColor(.white, for: .highlighted)
		ref = Database.database().reference()
		questionTextView.delegate = self
		questionTextView.text = "                        כתוב שאלה"
		questionTextView.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.questionTextView.becomeFirstResponder()
//		share()
    }
	@IBAction func trueAnswerTapped(_ sender: Any) {
//		UIView.animate(withDuration: 0.3) {
//			self.trueAnswerField.frame = CGRect(x: 0, y: 0, width: self.trueAnswerField.frame.width, height: self.trueAnswerField.frame.height)
//		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		maxCharLimit.text = String(questionTextView.text.count)
//		checkRemainingChars()
		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		let numberOfChars = newText.count
		return numberOfChars < 40    // 40 Limit Value
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
		let numberOfChars = newText.count
		return numberOfChars < 9    // 10 Limit Value
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func checkRemainingChars() {
		
		let remainingChars = 39-questionTextView.text.count
		
		if remainingChars >= 5 {
			maxCharLimit.textColor = .lightGray
		}
		
		if remainingChars <= 5 {
			maxCharLimit.textColor = .red
		}
		
		
		maxCharLimit.text = String(remainingChars)
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
    
	@IBAction func doneButtonTapped(_ sender: Any) {
		let userDefaults = UserDefaults.standard
		let userID = userDefaults.string(forKey: "userID")
		let time = Int(Date().timeIntervalSince1970)
		if questionTextView.text == "                        כתוב שאלה" {
			self.shake(view: self.questionView)
//			self.questionTextView.isUserInteractionEnabled = true
		}
		else {
//			let currentTime = time
//			let lastPostTime = UserDefaults.standard.integer(forKey: "lastPostTime")
//			if currentTime-lastPostTime >= 900 {} limit users
			let postRef = ref.child("Posts").child(userDefaults.string(forKey: "schoolSemel")!).child(String(time))
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
			UserDefaults.standard.set(time, forKey: "lastPostTime")
			performSegue(withIdentifier: "toMain", sender: self)
		}
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
			questionTextView.text = "                        כתוב שאלה"
			questionTextView.textColor = UIColor.lightGray
		}
	}

}


extension UIButton {
	func setBackgroundColor(color: UIColor, forState: UIControlState) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		self.setBackgroundImage(colorImage, for: forState)
	}}
