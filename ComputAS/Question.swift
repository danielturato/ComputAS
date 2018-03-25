//
//  File.swift
//  ComputAS
//
//  Created by Daniel Turato on 15/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import Foundation

class Question: NSObject, NSCoding { // has to follow the rules of these protocols: Allows to save as objects in UserDefaults
    
    var questionTitle: String
    var allAnswers: [String]
    var correctAnswer: String
    
    init(question title: String, answers allAnswers: [String], correctAnswer: String) { // Constructor
        
        self.questionTitle = title
        self.allAnswers = allAnswers
        self.correctAnswer = correctAnswer
        
    }
    
    required init(coder aDecoder: NSCoder) { //Required for the protocol (allows decoding on the object)
        
        self.questionTitle = aDecoder.decodeObject(forKey: "questionTitle") as? String ?? ""
        self.allAnswers = aDecoder.decodeObject(forKey: "allAnswers") as? [String] ?? [""]
        self.correctAnswer = aDecoder.decodeObject(forKey: "correctAnswer") as? String ?? ""
        
    }
    
    func encode(with aCoder: NSCoder) { // Required in the protocol (allows encoding on the object)
        
        aCoder.encode(questionTitle, forKey: "questionTitle")
        aCoder.encode(allAnswers, forKey: "allAnswers")
        aCoder.encode(correctAnswer, forKey: "correctAnswer")

    }

    
    
}














