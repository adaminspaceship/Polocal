//
//  Post.swift
//  Polocal
//
//  Created by Adam Eliezerov on 18/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import Foundation


class Post {
    
    var question = String()
    var falseAnswers = Int()
    var trueAnswers = Int()
    var postID = String()
	var trueAnswer = String()
	var falseAnswer = String()
    
	init(question: String, falseAnswers: Int, trueAnswers: Int, postID: String, trueAnswer: String?, falseAnswer: String?) {
        self.question = question
        self.falseAnswers = falseAnswers
        self.trueAnswers = trueAnswers
        self.postID = postID
		self.trueAnswer = trueAnswer ?? "כן"
		self.falseAnswer = falseAnswer ?? "לא"
    }
    
}
