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
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Posts = []
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let schoolSemel = UserDefaults.standard.string(forKey: "schoolSemel")!
        ref = Database.database().reference()
        ref.child(userID).child("Posts").observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let postUID = rest.value
                print(postUID)
                self.ref.child("Posts").child(schoolSemel).child(postUID as! String).observeSingleEvent(of: .value, with: { (querySnapShot) in
                    var finalJSON = JSON(querySnapShot.value)
                    let falseAnswers = finalJSON["answers"]["false"].intValue
                    let trueAnswers = finalJSON["answers"]["true"].intValue
                    let question = finalJSON["question"].stringValue
					self.Posts.append(Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: postUID as! String, trueAnswer: nil, falseAnswer: nil))
                    self.tableView.reloadData()
                })
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
