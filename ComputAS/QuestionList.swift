//
//  QuestionList.swift
//  ComputAS
//
//  Created by Daniel Turato on 15/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import Foundation
import Alamofire

class QuestionList {
    
    var questions: [Question]
    
    init(questions: [Question]) { // Requires a list of Questions
        
        self.questions = questions
        
    }
    
    // Use of a class func, creates an instance of QuestionList using saved list of questions
    class func allQuestions(unit: String) -> QuestionList {

        self.getRequiredQuestions(unit: unit)
        
        guard let questionsData = UserDefaults.standard.object(forKey: "allQuestions") as? NSData else {
            
            return QuestionList(questions: [Question]())
            
        }
        guard let questions = NSKeyedUnarchiver.unarchiveObject(with: questionsData as! Data) as? [Question] else {
            
            return QuestionList(questions: [Question]())
        }
        
        return QuestionList(questions: questions)
        
    }
    
    // Get random questions depedning on the unit, and save in UserDefaults as an array of Questions
    class func getRequiredQuestions(unit: String) {
        
        let path = Bundle.main.path(forResource: "questions", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        do {
            
            var questionsArray = [Question]()
            
            let data = try Data(contentsOf: url)
            // Read the json file
            let questionsJSON = try JSONDecoder().decode([String: [String: [String : [String]]]].self, from: data)
            let unitQuestions =  questionsJSON[unit] as! [String: [String : [String]]]
            // Set the questions in an array
            var questions = Array(unitQuestions.keys)
            
            var increment: Int = 0
            
            while increment < 10 {
                // Get a random index
                let randomIndex = Int(arc4random_uniform(UInt32(questions.count)))
                // Get the random question
                let questionTitle = questions[randomIndex]
                //Get the correctAnswer from that random questions
                let correctAnswer = unitQuestions[questionTitle]!["c"]![0] as! String
                // Get allAnswers from that random question
                let allAnswers = unitQuestions[questionTitle]!["i"] as! [String]
                
                //Create a new instance of Question and append it to the array
                questionsArray.append(Question(question: questionTitle, answers: allAnswers, correctAnswer: correctAnswer))
                questions.remove(at: randomIndex)
                increment += 1
                
            }
            // When 10 questions have been randomly picked, the array will be saved in user defaults
            let questionsData = NSKeyedArchiver.archivedData(withRootObject: questionsArray)
            UserDefaults.standard.set(questionsData, forKey: "allQuestions")
        }
        catch {}
        
        
        
    }
    
}














