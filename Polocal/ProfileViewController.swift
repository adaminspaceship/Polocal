//
//  ProfileViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 25/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var ref: DatabaseReference!
    var Posts = [Post]()
	@IBOutlet weak var popView: UIView!
	@IBOutlet weak var addQuestion: UIButton!
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
        let currentPost = Posts[indexPath.row]
        cell.questionLabel.text = currentPost.question
		
        cell.backgroundColor = .clear
        let sum = currentPost.falseAnswers+currentPost.trueAnswers
        if sum == 0 {
            cell.falsePercentLabel.text = "0%"
            cell.truePercentLabel.text = "0%"
        } else {
            let falsePercentage = Int((Double(currentPost.falseAnswers)/Double(sum))*100)
            let truePercentage = Int(100-falsePercentage)
            cell.falsePercentLabel.text = "\(falsePercentage)%"
            cell.truePercentLabel.text = "\(truePercentage)%"
        }
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		trueAnswerLabel.adjustsFontSizeToFitWidth = true
		falseAnswerLabel.adjustsFontSizeToFitWidth = true

        // Do any additional setup after loading the view.
		
    }
    
    override func viewDidAppear(_ animated: Bool) {
		addQuestion.isHidden = true
        Posts = []
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let schoolSemel = UserDefaults.standard.string(forKey: "schoolSemel")!
        ref = Database.database().reference()
        ref.child(userID).child("Posts").observeSingleEvent(of: .value) { (snapshot) in
			if snapshot.childrenCount == 0 {
				self.addQuestion.isHidden = false
			}
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let postUID = rest.value
                self.ref.child("Posts").child(schoolSemel).child(postUID as! String).observeSingleEvent(of: .value, with: { (querySnapShot) in
					var finalJSON = JSON(querySnapShot.value!)
                    let falseAnswers = finalJSON["answers"]["false"].intValue
                    let trueAnswers = finalJSON["answers"]["true"].intValue
					let trueAnswer = finalJSON["trueAnswer"].stringValue
					let falseAnswer = finalJSON["falseAnswer"].stringValue
                    let question = finalJSON["question"].stringValue
					let post = Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: postUID as! String, trueAnswer: trueAnswer, falseAnswer: falseAnswer, timestamp: nil)
					self.Posts.insert(post, at: 0)
                    self.tableView.reloadData()
                })
            }
        }
    }
	
	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var trueAnswerLabel: UILabel!
	@IBOutlet weak var falseAnswerLabel: UILabel!
	@IBOutlet weak var truePercentageLabel: UILabel!
	@IBOutlet weak var falsePercentageLabel: UILabel!
	
	var selectedPostIndex = IndexPath()
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if Posts.count == 0 {
			print("no posts for user")
			addQuestion.isHidden = false
		} else {
			let currentPost = Posts[indexPath.row]
			questionLabel.text = currentPost.question
			trueAnswerLabel.text = currentPost.trueAnswer
			falseAnswerLabel.text = currentPost.falseAnswer
			selectedPostIndex = indexPath
			let (falsePerc,truePerc) = calcPercentage(trueAnswers: currentPost.trueAnswers, falseAnswers: currentPost.falseAnswers)
			falsePercentageLabel.text = "\(String(falsePerc))%"
			truePercentageLabel.text = "\(String(truePerc))%"
			bgChange(isAlready: false)
		}
	}

//	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//		bgChange(isAlready: true)
//	}
	@IBAction func closeButtonTapped(_ sender: Any) {
		bgChange(isAlready: true)
	}
	
	@IBAction func addQuestionTapped(_ sender: Any) {
		tabBarController?.selectedIndex = 1
	}
	
	func bgChange(isAlready: Bool) {
		//changing alpha
		if isAlready {
			UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
				self.popView.isHidden = true
			})
			tableView.alpha = 1
		} else {
			UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
				self.popView.isHidden = false
			})
			tableView.alpha = 0.25
		}
		
	}
	@IBAction func deletePostButtonTapped(_ sender: Any) {
		bgChange(isAlready: true)
		let selectedPost = Posts[selectedPostIndex.row]
		let userRef = Database.database().reference().child(UserDefaults.standard.string(forKey: "userID")!).child("Posts")
		let postRef = Database.database().reference().child("Posts").child(UserDefaults.standard.string(forKey: "schoolSemel")!)
		userRef.child(selectedPost.postID).removeValue()
		postRef.child(selectedPost.postID).removeValue()
		Posts.remove(at: selectedPostIndex.row)
		tableView.reloadData()
	}
	
	func calcPercentage(trueAnswers: Int, falseAnswers: Int) -> (Int,Int) {
		let sum = falseAnswers+trueAnswers
		if sum == 0 {
			return (0,0)
		} else {
			let truePercentage = Int((Double(trueAnswers)/Double(sum))*100)
			let falsePercentage = Int(100-truePercentage)
			return (falsePercentage,truePercentage)
		}
	}
}

extension ProfileViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
						   shouldReceive touch: UITouch) -> Bool {
		return (touch.view === self.view)
	}
}
