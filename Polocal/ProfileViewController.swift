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
        cell.questionLabel.text = Posts[indexPath.row].question
        cell.backgroundColor = .clear
        
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    self.Posts.append(Post(question: question, falseAnswers: falseAnswers, trueAnswers: trueAnswers, postID: postUID as! String))
                    self.tableView.reloadData()
                })
            }
        }
        // Do any additional setup after loading the view.
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
