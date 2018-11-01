//
//  MainViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 18/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

//					if self.trueLabel.font.pointSize < self.falseLabel.font.pointSize {
//						self.falseLabel.font.withSize(CGFloat(30))
//					} else if self.falseLabel.font.pointSize < self.trueLabel.font.pointSize {
//						self.trueLabel.font.withSize(self.falseLabel.font.pointSize)
//					} else {
//						break
//					}
//let queryRef = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).queryOrdered(byChild: "usersRead/\(userid ?? "")").queryEqual(toValue: "\(userid ?? "")")



import UIKit
import FirebaseDatabase
import SwiftyJSON
import DateTools

class MainViewController: UIViewController {

    @IBOutlet var questionLabel: UILabel!
    var ref: DatabaseReference!
    @IBOutlet var falsePercentageLabel: UILabel!
    @IBOutlet var truePercentageLabel: UILabel!
    @IBOutlet var trueView: UIView!
    @IBOutlet var falseView: UIView!
	@IBOutlet weak var placeholderQuestion: UIView!
	@IBOutlet weak var falseButton: UIButton!
	@IBOutlet weak var trueButton: UIButton!
	@IBOutlet weak var answerView: UIView!
    @IBOutlet weak var trueLabel: UILabel!
    @IBOutlet weak var falseLabel: UILabel!
	@IBOutlet weak var timeAgoLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var midView: UIView!
	@IBOutlet weak var addQuestionButton: UIButton!
	
	var totalPosts = [String]()
	var currentPost = [Post]()
	var readPosts = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		var newFrame = trueView.frame
//		newFrame.size.width = answerView.frame.width
//		trueView.frame = newFrame
		//print(UserDefaults.standard.string(forKey: "userID"))
		
//		for i in 1...999{
//			let ref = Database.database().reference().child("Posts").child("540211")
//			let new = ["answers":["false":4,"true":1],"falseAnswer":"לא","question":"מימ?","timestamp":1540469825,"trueAnswer":"כן"] as [String : Any]
//			ref.child(String(i)).setValue(new)
//		}
		
    } //end of viewdidload()
	
	override func viewDidAppear(_ animated: Bool) {
		trueLabel.adjustsFontSizeToFitWidth = true
		falseLabel.adjustsFontSizeToFitWidth = true
		trueLabel.lineBreakMode = .byTruncatingTail
		falseLabel.lineBreakMode = .byTruncatingTail
		falsePercentageLabel.isHidden = true
		truePercentageLabel.isHidden = true
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		getReadPosts()
		let greyColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:0.8)
		falseButton.setBackgroundColor(color: greyColor, forState: .highlighted)
		trueButton.setBackgroundColor(color: greyColor, forState: .highlighted)
		falseButton.setTitleColor(.white, for: .highlighted)
		trueButton.setTitleColor(.white, for: .highlighted)
	}
	
	
	
	func getReadPosts() {
		let userid = UserDefaults.standard.string(forKey: "userID")
		let ref = Database.database().reference().child(userid!).child("readPosts")
		ref.observeSingleEvent(of: .value) { (snapshot) in
			let enumerator = snapshot.children
			let childCount = snapshot.childrenCount
			var count = 0
			if childCount == 0 {
				self.getAllPosts()
			} else {
				while let rest = enumerator.nextObject() as? DataSnapshot {
					count += 1
					let json = JSON(rest.value!)
					let postID = json.stringValue
					self.readPosts.append(postID)
					if childCount == count {
						self.getAllPosts()
					}
				}
			}
		}
	}

	
	func getAllPosts() {
		let ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).queryLimited(toLast: 200)
		ref.observeSingleEvent(of: .value) { (snapshot) in
			if let result = snapshot.children.allObjects as? [DataSnapshot] {
				if snapshot.childrenCount == 0 {
					self.defaultQuestion()
				} else {
					var counter = 0
					for child in result {
						counter += 1
						if !self.readPosts.contains(child.key) {
							self.totalPosts.append(child.key)
						}
						if counter == snapshot.childrenCount {
							self.checkRead()
						}
					}
				}
			}
		}
	}
	

	func defaultQuestion() {
		let defaultQuestionRef = Database.database().reference().child("defaultQuestions")
		defaultQuestionRef.observeSingleEvent(of: .value) { (snap) in
			let enumerator = snap.children
			var count = 0
			while let rest = enumerator.nextObject() as? DataSnapshot {
				let json = JSON(rest.value!)
				let falseAnswer = json["falseAnswer"].stringValue
				let trueAnswer = json["trueAnswer"].stringValue
				let falseAnswers = json["answers"]["false"].intValue
				let trueAnswers = json["answers"]["true"].intValue
				let question = json["question"].stringValue
				let time = count
				count += 1
				let moreRef = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).child(String(time))
				let defaultQuestion = ["answers":["false":falseAnswers,"true":trueAnswers],"question":question,"trueAnswer":trueAnswer,"falseAnswer":falseAnswer,"timestamp":time] as [String : Any]
				moreRef.setValue(defaultQuestion){
					(error:Error?, ref:DatabaseReference) in
					if let error = error {
						print("Data could not be saved: \(error).")
					} else {
						print("Data saved successfully!")
						sleep(1)
						self.getReadPosts()
					}
				}
			}
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
    func checkRead(postID: String? = "0000000", greaterPerc: String? = "true" ,num: Double? = 0.0) {
		self.activityIndicator.startAnimating()
        self.placeholderQuestion.isHidden = true
		trueButton.isEnabled = true
		falseButton.isEnabled = true
        self.falseLabel.textColor = UIColor(red:0.00, green:0.77, blue:0.80, alpha:1.0)
        self.trueLabel.textColor = UIColor(red:0.00, green:0.77, blue:0.80, alpha:1.0)
		
        if greaterPerc == "true" {
            UIView.animate(withDuration: 0.5) {
                for _ in 0...Int(num!) {
                    self.trueView.center = CGPoint(x: self.trueView.center.x+1, y: self.trueView.center.y)
                }
            }
        } else if greaterPerc == "false" {
            UIView.animate(withDuration: 0.5) {
                self.falseView.frame.size.width = 0
            }
        } else if greaterPerc == "equals"{
            UIView.animate(withDuration: 0.5) {
                self.falseView.frame.size.width = 0
				let half = self.answerView.frame.size.width/2
                for _ in 0...Int(half)  {
                    self.trueView.center = CGPoint(x: self.trueView.center.x+1, y: self.trueView.center.y)
                }
            }
        }
		
		if totalPosts.count == 0 {
			noMorePosts()
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
		} else {
			let queryRef = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).child(totalPosts[totalPosts.count-1])
			
			queryRef.observeSingleEvent(of: .value) { (snapshot) in
				let json = JSON(snapshot.value!)
				let question = json["question"].stringValue
				let falseAnswers = json["answers"]["false"].intValue
				let trueAnswers = json["answers"]["true"].intValue
				let trueAnswer = json["trueAnswer"].stringValue
				let falseAnswer = json["falseAnswer"].stringValue
				let timestamp = json["timestamp"].intValue
				self.currentPost.removeAll()
				self.currentPost.append(Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: snapshot.key, trueAnswer: trueAnswer, falseAnswer: falseAnswer, timestamp: timestamp))
				let current = self.currentPost[0]
				self.questionLabel.text = current.question
				//print(currentPost.question)
				self.questionLabel.isHidden = false
				self.trueLabel.text = current.trueAnswer
				self.falseLabel.text = current.falseAnswer
				let date = NSDate(timeIntervalSince1970: TimeInterval(current.timestamp))
				self.timeAgoLabel.text = date.shortTimeAgoSinceNow()
				self.activityIndicator.stopAnimating()
				self.addQuestionButton.isHidden = true
				self.activityIndicator.isHidden = true
			}
		}
	}
    

	func noMorePosts(greaterPerc: String? = "false", num: Double? = 0.0) {
		
		if greaterPerc == "true" {
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
				for _ in 0...Int(num!) {
					self.trueView.center = CGPoint(x: self.trueView.center.x+1, y: self.trueView.center.y)
				}
			})
		} else if greaterPerc == "false" {
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = 0
			})
		} else if greaterPerc == "equals"{
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = 0
				let half = self.answerView.frame.size.width/2
				for _ in 0...Int(half)  {
					self.trueView.center = CGPoint(x: self.trueView.center.x+1, y: self.trueView.center.y)
				}
			})
		}
		
		print("error, no more polls")
		self.placeholderQuestion.isHidden = false
		self.questionLabel.isHidden = true
		
		self.falseLabel.textColor = .lightGray
		self.trueLabel.textColor = .lightGray
		self.falseButton.isEnabled = false
		self.trueButton.isEnabled = false
		self.falseLabel.text = "לא"
		self.trueLabel.text = "כן"
		self.timeAgoLabel.text = ""
		// make user create a new poll
		UIView.animate(withDuration: 0.2) {
			self.addQuestionButton.isHidden = false
		}
		
	}
	
	func calcPercentage(trueAnswers: Int, falseAnswers: Int, Added: Bool) -> (Int,Int) {
		if Added == true {
			let sum = falseAnswers+trueAnswers
			let truePercentage = Int((Double(trueAnswers)/Double(sum))*100)
			let falsePercentage = Int(100-truePercentage)
//			showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
			return (falsePercentage,truePercentage)
		} else {
			let sum = falseAnswers+trueAnswers
			let falsePercentage = Int((Double(falseAnswers)/Double(sum))*100)
			let truePercentage = Int(100-falsePercentage)
//			showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
			return (falsePercentage,truePercentage)
		}
	}

	@IBAction func trueAnswerButtonTouched(_ sender: Any) {
		falseButton.isEnabled = false
	}

	@IBAction func trueAnswerButtonReleased(_ sender: Any) {
		trueButton.isEnabled = false
		if self.currentPost.count == 0 {
			print("wait")
		} else {
			let currentPost = self.currentPost[0]
			let trueAnswers = currentPost.trueAnswers
			let newTrueAnswers = trueAnswers+1
			ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
			ref.child(currentPost.postID).child("answers").child("true").setValue(newTrueAnswers)
			truePercentageLabel.isHidden = false
			falsePercentageLabel.isHidden = false
			let (falsePercentage, truePercentage) = calcPercentage(trueAnswers: newTrueAnswers, falseAnswers: currentPost.falseAnswers, Added: true)
			truePercentageLabel.text = "\(String(truePercentage))%"
			falsePercentageLabel.text = "\(String(falsePercentage))%"
			showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
			didReadPost(postID: currentPost.postID, answer: "true")
			self.totalPosts.removeLast()
		}
	}
	@IBAction func falseAnswerButtonTapped(_ sender: Any) {
		trueButton.isEnabled = false
	}
	@IBAction func falseAnswerButtonReleased(_ sender: Any) {
		falseButton.isEnabled = false
		if self.currentPost.count == 0 {
			print("wait")
		} else {
			let currentPost = self.currentPost[0]
			let falseAnswers = currentPost.falseAnswers
			let newFalseAnswers = falseAnswers+1
			ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
			ref.child(currentPost.postID).child("answers").child("false").setValue(newFalseAnswers)
			let (falsePercentage, truePercentage) = calcPercentage(trueAnswers: currentPost.trueAnswers, falseAnswers: newFalseAnswers, Added: false)
			falsePercentageLabel.isHidden = false
			truePercentageLabel.isHidden = false
			truePercentageLabel.text = "\(String(truePercentage))%"
			falsePercentageLabel.text = "\(String(falsePercentage))%"
			showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
			didReadPost(postID: currentPost.postID, answer: "false")
			self.totalPosts.removeLast()
		}
	}
	
	@IBAction func addQuestionButtonTapped(_ sender: Any) {
		tabBarController?.selectedIndex = 1
	}
	
	func didReadPost(postID: String, answer: String) {
		ref = Database.database().reference()
		ref.child(UserDefaults.standard.string(forKey: "userID")!).child("readPosts").child(postID).setValue(postID)
	}
	
	func showPercentage(falsePercentage: Int, truePercentage: Int) {
		if falsePercentage>truePercentage {
			let num = Double(self.answerView.frame.width)/(100/Double(falsePercentage))
			UIView.animate(withDuration: 1.3, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = CGFloat(num)
			}) { (complete) in
				sleep(2)
				self.truePercentageLabel.isHidden = true
				self.falsePercentageLabel.isHidden = true
				self.checkRead(greaterPerc: "false", num: num)
			}
		} else if truePercentage>falsePercentage {
			let num = Double(self.answerView.frame.width)/(100/Double(truePercentage))
			self.trueView.isHidden = false
			UIView.animate(withDuration: 1.3, delay: 0, options: .curveEaseIn, animations: {
				for _ in 0...Int(num) {
					self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
				}
			}) { (complete) in
				sleep(1)
				self.truePercentageLabel.isHidden = true
				self.falsePercentageLabel.isHidden = true
				self.checkRead(greaterPerc: "true", num: num)
				
			}
		} else {
			UIView.animate(withDuration: 1.3, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = CGFloat(self.answerView.frame.width/2)
				for _ in 0...Int(self.answerView.frame.width/2) {
					self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
				}
			}) { (complete) in
				sleep(1)
				self.truePercentageLabel.isHidden = true
				self.falsePercentageLabel.isHidden = true
				self.checkRead(greaterPerc: "equals")
			}
			
		}
	}
	@IBAction func goToSettings(_ sender: Any) {
		self.performSegue(withIdentifier: "toSettings", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toSettings" {
			let destinationVC = segue.destination as! SettingsTableViewController
			if currentPost.count != 0{
				destinationVC.postID = currentPost[0].postID
			} else {
				destinationVC.postID = "1"
			}
			
		}
		
	}

	
	
}
