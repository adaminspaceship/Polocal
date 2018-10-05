//
//  MainViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 18/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

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
    
    var Posts = [Post]()
    var postCount = -1

    override func viewDidLoad() {
        super.viewDidLoad()
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
		swipeLeft.direction = .left
		self.view.addGestureRecognizer(swipeLeft)
        let time = Int(Date().timeIntervalSince1970)
        print(time)
        falsePercentageLabel.isHidden = true
        truePercentageLabel.isHidden = true
        // instead of child blich change it to user defaults uid
        ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let json = JSON(rest.value)
                let question = json["question"].stringValue
                let falseAnswers = json["answers"]["false"].intValue
                let trueAnswers = json["answers"]["true"].intValue
                self.Posts.append(Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: rest.key))
				self.postCount += 1
            }
            if self.Posts.count == 0 {
                self.placeholderQuestion.isHidden = false
                self.falseLabel.textColor = .lightGray
                self.trueLabel.textColor = .lightGray
            } else {
                self.checkRead(postID: self.Posts[self.postCount].postID)
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
    func checkRead(postID: String, greaterPerc: String? = "true" ,num: Double? = 0.0) {
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
		
        ref = Database.database().reference()
		ref.child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).child(postID).child("usersRead").observeSingleEvent(of: .value) { (snapshot) in
			for rest in snapshot.children.allObjects as! [DataSnapshot] {
				let userID = rest.value as! String
				if UserDefaults.standard.string(forKey: "userID") == userID {
					print("error, no more polls")
					self.placeholderQuestion.isHidden = false
                    self.falseLabel.textColor = .lightGray
                    self.trueLabel.textColor = .lightGray
					self.falseButton.isEnabled = false
					self.trueButton.isEnabled = false
					break
				} else {
					let currentPost = self.Posts[self.postCount]
					self.questionLabel.text = currentPost.question
				}
			}
			
		}
	}
    
    @IBAction func falseAnswerButtonTapped(_ sender: Any) {
		falseButton.isEnabled = false
		trueButton.isEnabled = false
        let currentPost = Posts[postCount]
        let falseAnswers = currentPost.falseAnswers
        let newFalseAnswers = falseAnswers+1
		ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
        ref.child(currentPost.postID).child("answers").child("false").setValue(newFalseAnswers)
        let sum = newFalseAnswers+currentPost.trueAnswers
		let falsePercentage = Int((Double(newFalseAnswers)/Double(sum))*100)
        let truePercentage = Int(100-falsePercentage)
        falsePercentageLabel.isHidden = false
        truePercentageLabel.isHidden = false
        truePercentageLabel.text = "\(String(truePercentage))%"
        falsePercentageLabel.text = "\(String(falsePercentage))%"
        showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
		didReadPost(postID: currentPost.postID, answer: "false")
		postCount -= 1
    }
    var timer = Timer()
    
    
    @IBAction func trueAnswerButtonTapped(_ sender: Any) {
		trueButton.isEnabled = false
		falseButton.isEnabled = false
        let currentPost = Posts[postCount]
        let trueAnswers = currentPost.trueAnswers
        let newTrueAnswers = trueAnswers+1
        ref = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
        ref.child(currentPost.postID).child("answers").child("true").setValue(newTrueAnswers)
        let sum = currentPost.falseAnswers+newTrueAnswers
		let truePercentage = Int((Double(newTrueAnswers)/Double(sum))*100)
        let falsePercentage = Int(100-truePercentage)
        truePercentageLabel.isHidden = false
        falsePercentageLabel.isHidden = false
        truePercentageLabel.text = "\(String(truePercentage))%"
        falsePercentageLabel.text = "\(String(falsePercentage))%"
		showPercentage(falsePercentage: falsePercentage, truePercentage: truePercentage)
		didReadPost(postID: currentPost.postID, answer: "true")
		postCount -= 1
    }
	
	
	
	func didReadPost(postID: String, answer: String) {
		ref = Database.database().reference()
//		ref.child(UserDefaults.standard.string(forKey: "userID")!).child("readPosts").child(postID).setValue(answer)
		ref.child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!).child(postID).child("usersRead").childByAutoId().setValue(UserDefaults.standard.string(forKey: "userID")!)
	}
	
	func showPercentage(falsePercentage: Int, truePercentage: Int) {
		if falsePercentage>truePercentage {
			let num = Double(self.answerView.frame.width)/(100/Double(falsePercentage))
			UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = CGFloat(num)
			}) { (complete) in
                sleep(3)
                self.truePercentageLabel.isHidden = true
                self.falsePercentageLabel.isHidden = true
                if self.Posts.count == 0 {
                    self.placeholderQuestion.isHidden = false
                    self.falseLabel.textColor = .lightGray
                    self.trueLabel.textColor = .lightGray
                } else {
                    let currentPost = self.Posts[self.postCount]
                    self.checkRead(postID: currentPost.postID, greaterPerc: "false", num: num)
                }
			}
		} else if truePercentage>falsePercentage {
			let num = Double(self.answerView.frame.width)/(100/Double(truePercentage))
			self.trueView.isHidden = false
			UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
				for _ in 0...Int(num) {
                    self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
				}
			}) { (complete) in
                sleep(3)
                self.truePercentageLabel.isHidden = true
                self.falsePercentageLabel.isHidden = true
                if self.Posts.count == 0 {
                    self.placeholderQuestion.isHidden = false
                    self.falseLabel.textColor = .lightGray
                    self.trueLabel.textColor = .lightGray
                } else {
                    let currentPost = self.Posts[self.postCount]
                    self.checkRead(postID: currentPost.postID, greaterPerc: "true", num: num)
                }
			}
		} else {
			UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
				self.falseView.frame.size.width = CGFloat(self.answerView.frame.size.width/2)
				for _ in 0...Int(self.answerView.frame.width/2) {
					self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
				}
			}) { (complete) in
                sleep(3)
                self.truePercentageLabel.isHidden = true
                self.falsePercentageLabel.isHidden = true
                if self.Posts.count == 0 {
                    self.placeholderQuestion.isHidden = false
                    self.falseLabel.textColor = .lightGray
                    self.trueLabel.textColor = .lightGray
                } else {
                    let currentPost = self.Posts[self.postCount]
                    self.checkRead(postID: currentPost.postID, greaterPerc: "equals")
                }
			}
			
		}
	}
    
}



