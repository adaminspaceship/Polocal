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
    
    var Posts = [Post]()
    var postCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let time = Int(Date().timeIntervalSince1970)
        print(time)
        falsePercentageLabel.isHidden = true
        truePercentageLabel.isHidden = true
        // instead of child blich change it to user defaults uid
        ref = Database.database().reference().child("Posts").child("blich")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let json = JSON(rest.value)
                let question = json["question"].stringValue
                let falseAnswers = json["answers"]["false"].intValue
                let trueAnswers = json["answers"]["true"].intValue
                self.Posts.append(Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: rest.key))
                let currentPost = self.Posts[self.postCount]
                self.questionLabel.text = currentPost.question
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func readNewPost() {
        postCount += 1
        let currentPost = Posts[postCount]
        questionLabel.text = currentPost.question
        truePercentageLabel.isHidden = true
        falsePercentageLabel.isHidden = true
        
    }
    
    @IBAction func falseAnswerButtonTapped(_ sender: Any) {
        let currentPost = Posts[postCount]
        let falseAnswers = currentPost.falseAnswers
        let newFalseAnswers = falseAnswers+1
        ref = Database.database().reference().child("Posts").child("blich")
        ref.child(currentPost.postID).child("answers").child("false").setValue(newFalseAnswers)
        let sum = currentPost.falseAnswers+currentPost.trueAnswers
        let falsePercentage = Int((Double(currentPost.falseAnswers)/Double(sum))*100)
        let truePercentage = Int(100-falsePercentage)
        falsePercentageLabel.isHidden = false
        truePercentageLabel.isHidden = false
        truePercentageLabel.text = "\(String(truePercentage))%"
        falsePercentageLabel.text = "\(String(falsePercentage))%"
        if falsePercentage>truePercentage {
            UIView.animate(withDuration: 1) {
                let num = 319/(100/Double(falsePercentage))
                self.falseView.frame.size.width = CGFloat(num)
            }
        }else {
            UIView.animate(withDuration: 1) {
                let num = 319/(100/Double(truePercentage))
                self.trueView.isHidden = false
                for i in 0...Int(num) {
                    self.trueView.frame.size.width += 1
                    self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
                }
            }
        }
        
    }
    
    var timer = Timer()
    
    
    @IBAction func trueAnswerButtonTapped(_ sender: Any) {
        let currentPost = Posts[postCount]
        let trueAnswers = currentPost.trueAnswers
        let newTrueAnswers = trueAnswers+1
        ref = Database.database().reference().child("Posts").child("blich")
        ref.child(currentPost.postID).child("answers").child("true").setValue(newTrueAnswers)
        let sum = currentPost.falseAnswers+currentPost.trueAnswers
        let falsePercentage = Int((Double(currentPost.falseAnswers)/Double(sum))*100)
        let truePercentage = Int(100-falsePercentage)
        truePercentageLabel.isHidden = false
        falsePercentageLabel.isHidden = false
        
        truePercentageLabel.text = "\(String(truePercentage))%"
        falsePercentageLabel.text = "\(String(falsePercentage))%"
        if falsePercentage>truePercentage {
            let num = 319/(100/Double(falsePercentage))
            UIView.animate(withDuration: 1, animations: {
                self.falseView.frame.size.width = CGFloat(num)
            }) { (complete) in
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.readNewPost), userInfo: nil, repeats: false)
                UIView.animate(withDuration: 1, animations: {
                    for i in 0...Int(num) {
                        self.falseView.frame.size.width = 0
                    }
                })
                
            }
        }else {
            let num = 319/(100/Double(truePercentage))
            self.trueView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                for i in 0...Int(num) {
                    self.trueView.frame.size.width += 1
                    self.trueView.center = CGPoint(x: self.trueView.center.x-1, y: self.trueView.center.y)
                }
            }) { (complete) in
                UIView.animate(withDuration: 1, animations: {
                    for i in 0...Int(num) {
                        self.trueView.frame.size.width -= 1
                        self.trueView.center = CGPoint(x: self.trueView.center.x+1, y: self.trueView.center.y)
                    }
                })
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.readNewPost), userInfo: nil, repeats: false)
            }
        }
    }
    
}



