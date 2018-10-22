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
	var gotitall = 0
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
    var Posts = [Post]()
    var postCount = -1
	var readPosts = [String]()
	var totalPosts = [String]()
	var currentPost = [Post]()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//print(UserDefaults.standard.string(forKey: "userID"))
		trueLabel.adjustsFontSizeToFitWidth = true
		falseLabel.adjustsFontSizeToFitWidth = true
		trueLabel.lineBreakMode = .byTruncatingTail
		falseLabel.lineBreakMode = .byTruncatingTail
		
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
		swipeLeft.direction = .left
		self.view.addGestureRecognizer(swipeLeft)
        falsePercentageLabel.isHidden = true
        truePercentageLabel.isHidden = true
		
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		getAllPosts()
		getReadPosts()
		

		
    } //end of viewdidload()
	
	
	
	func getReadPosts() {
		let userid = UserDefaults.standard.string(forKey: "userID")
		let ref = Database.database().reference().child(userid!).child("readPosts")
		ref.observeSingleEvent(of: .value) { (snapshot) in
			let enumerator = snapshot.children
			let childCount = snapshot.childrenCount
			var count = 0
			while let rest = enumerator.nextObject() as? DataSnapshot {
				count += 1
				let json = JSON(rest.value!)
				let postID = json.stringValue
				if self.totalPosts.contains(postID) {
					if let index = self.totalPosts.index(of: postID) {
						self.totalPosts.remove(at: index)
					}
				} else {
					continue
				}
				if childCount == count {
					self.activityIndicator.stopAnimating()
					self.activityIndicator.isHidden = true
					self.checkRead()
				}
			}
		}
	}
	
	func getAllPosts() {
		let queryRef = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
		queryRef.observeSingleEvent(of: .value) { (snapshot) in
			if let result = snapshot.children.allObjects as? [DataSnapshot] {
				for child in result {
					let postUID = child.key
					self.totalPosts.append(postUID)
				}
			}
		}
	}
	
	func oldGetPosts() {
		let userid = UserDefaults.standard.string(forKey: "userID")
		let ref = Database.database().reference().child(userid!).child("readPosts")
		let queryRef = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
		
		queryRef.observeSingleEvent(of: .value) { (snapshot) in
			print("started")
			let enumerator = snapshot.children
			
			while let rest = enumerator.nextObject() as? DataSnapshot {
				let json = JSON(rest.value!)
				let question = json["question"].stringValue
				let falseAnswers = json["answers"]["false"].intValue
				let trueAnswers = json["answers"]["true"].intValue
				let trueAnswer = json["trueAnswer"].stringValue
				let falseAnswer = json["falseAnswer"].stringValue
				let timestamp = json["timestamp"].intValue
				//print("trueAnswer: \(trueAnswer), falseAnswer: \(falseAnswer)")
				ref.observeSingleEvent(of: .value) { (snap) in
					if snap.hasChild(rest.key) {
						print("already answered question: \(question)")
					} else {
						print("not yet answered, adding question: \(question) to Posts")
						self.Posts.append(Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: rest.key, trueAnswer: trueAnswer, falseAnswer: falseAnswer, timestamp: timestamp))
						self.postCount += 1
						print(self.postCount)
						if self.gotitall == self.postCount {
							print("done1")
						}
						if 13 == self.postCount-1 {
							print("done2")
						}
						self.checkRead(postID: self.Posts[self.postCount].postID)
						
					}
					print("check")
				}
				
			}
			
			
			
		}
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
		if gesture.direction == UISwipeGestureRecognizerDirection.left {
			print("Swipe Left")
			performSegue(withIdentifier: "toSideMenu", sender: self)
		}
		
	}
	
	
    func checkRead(postID: String? = "0000000", greaterPerc: String? = "true" ,num: Double? = 0.0) {
		
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
				self.trueLabel.text = current.trueAnswer
				self.falseLabel.text = current.falseAnswer
				let date = NSDate(timeIntervalSince1970: TimeInterval(current.timestamp))
				self.timeAgoLabel.text = date.shortTimeAgoSinceNow()
			}
		}
	}
    

	func noMorePosts(greaterPerc: String? = "false", num: Double? = 0.0) {
		
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
		
		print("error, no more polls")
		self.placeholderQuestion.isHidden = false
		self.falseLabel.textColor = .lightGray
		self.trueLabel.textColor = .lightGray
		self.falseButton.isEnabled = false
		self.trueButton.isEnabled = false
		self.falseLabel.text = "לא"
		self.trueLabel.text = "כן"
		self.timeAgoLabel.text = "n/a"
		// make user create a new poll
	}
	
	func calcPercentage(trueAnswers: Int, falseAnswers: Int, Added: Bool) -> (Int,Int) {
		if Added == true {
			let newTrueAnswers = trueAnswers+1
			let sum = falseAnswers+newTrueAnswers
			let truePercentage = Int((Double(newTrueAnswers)/Double(sum))*100)
			let falsePercentage = Int(100-truePercentage)
			return (falsePercentage,truePercentage)
		} else {
			let newFalseAnswers = falseAnswers+1
			let sum = newFalseAnswers+trueAnswers
			let falsePercentage = Int((Double(newFalseAnswers)/Double(sum))*100)
			let truePercentage = Int(100-falsePercentage)
			return (falsePercentage,truePercentage)
		}
	}

	@IBAction func trueAnswerButtonTouched(_ sender: Any) {
		trueButton.isEnabled = false
		falseButton.isEnabled = false
		let currentPost = self.currentPost[0]
		let trueAnswers = currentPost.trueAnswers
		let newTrueAnswers = trueAnswers+1
		ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
		ref.child(currentPost.postID).child("answers").child("true").setValue(newTrueAnswers)
		truePercentageLabel.isHidden = false
		falsePercentageLabel.isHidden = false
		let (falsePercentage, truePercentage) = calcPercentage(trueAnswers: currentPost.falseAnswers, falseAnswers: currentPost.falseAnswers, Added: true)
		truePercentageLabel.text = "\(String(truePercentage))%"
		falsePercentageLabel.text = "\(String(falsePercentage))%"
		showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
		didReadPost(postID: currentPost.postID, answer: "true")
		self.totalPosts.removeLast()
	}

	@IBAction func falseAnswerButtonTapped(_ sender: Any) {
		falseButton.isEnabled = false
		trueButton.isEnabled = false
		let currentPost = self.currentPost[0]
		let falseAnswers = currentPost.falseAnswers
		let newFalseAnswers = falseAnswers+1
		ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
		ref.child(currentPost.postID).child("answers").child("false").setValue(newFalseAnswers)
		let (falsePercentage, truePercentage) = calcPercentage(trueAnswers: currentPost.falseAnswers, falseAnswers: currentPost.falseAnswers, Added: false)
		falsePercentageLabel.isHidden = false
		truePercentageLabel.isHidden = false
		truePercentageLabel.text = "\(String(truePercentage))%"
		falsePercentageLabel.text = "\(String(falsePercentage))%"
		showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
		didReadPost(postID: currentPost.postID, answer: "false")
		self.totalPosts.removeLast()
	}
	
	
	
	func didReadPost(postID: String, answer: String) {
		ref = Database.database().reference()
		ref.child(UserDefaults.standard.string(forKey: "userID")!).child("readPosts").child(postID).setValue(postID)
	}
	
	func showPercentage(falsePercentage: Int, truePercentage: Int) {
		if falsePercentage>truePercentage {
			let num = Double(self.answerView.frame.width)/(100/Double(falsePercentage))
			UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = CGFloat(num)
			}) { (complete) in
                sleep(2)
                self.truePercentageLabel.isHidden = true
                self.falsePercentageLabel.isHidden = true
				self.checkRead(greaterPerc: "false", num: num)
//                if self.Posts.count == 0 {
//                    self.placeholderQuestion.isHidden = false
//                    self.falseLabel.textColor = .lightGray
//                    self.trueLabel.textColor = .lightGray
//                } else {
//					self.checkRead(greaterPerc: "false", num: num)
//					//self.noMorePosts(greaterPerc: "false")
//                }
			}
		} else if truePercentage>falsePercentage {
			let num = Double(self.answerView.frame.width)/(100/Double(truePercentage))
			self.trueView.isHidden = false
			UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
				for _ in 0...Int(num) {
                    self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
				}
			}) { (complete) in
                sleep(2)
                self.truePercentageLabel.isHidden = true
                self.falsePercentageLabel.isHidden = true
				self.checkRead(greaterPerc: "true", num: num)
				
			}
		} else {
			UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = CGFloat(self.answerView.frame.size.width/2)
				for _ in 0...Int(self.answerView.frame.width/2) {
					self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
				}
			}) { (complete) in
                sleep(2)
                self.truePercentageLabel.isHidden = true
                self.falsePercentageLabel.isHidden = true
				self.checkRead(greaterPerc: "equals")
			}
			
		}
	}
}
