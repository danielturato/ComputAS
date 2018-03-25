//
//  IndivualQuizViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 11/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

// An extension to the UIView functionality giving me the ability to use a fade transition
extension UIView {
    
    func fadeTransition(_ duration: CFTimeInterval) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
        
    }
    
}

class IndivualQuizViewController: UIViewController { // Class inherits from UIViewController
    
    // Sets the outlets connected to the view
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    @IBOutlet weak var aOneLabel: UIButton!
    @IBOutlet weak var aTwoLabel: UIButton!
    @IBOutlet weak var aThreeLabel: UIButton!
    @IBOutlet weak var aFourLabel: UIButton!
    
    @IBOutlet weak var timerProgressView: UIProgressView!
    
    // Starting global variables required at the start of the quiz
    var unit: String?
    var questionChoice: String = ""
    var timeDelay = 10
    var timer = Timer()
    var currentQuestionIndex: Int = 0
    var runningTotal = 0
    var questionNumber = 1
    
    var questions = QuestionList.allQuestions(unit: "UnitFourTwo").questions // Get a random list of questions
    
    let blue = UIColor(red:0.29, green:0.81, blue:0.98, alpha:1.0)
    let navy = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
    
    // When the view loads, this function will execute
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting dimensions of the text in answer boxes
        aOneLabel.titleLabel?.textAlignment = NSTextAlignment.center
        aOneLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        aTwoLabel.titleLabel?.textAlignment = NSTextAlignment.center
        aTwoLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        aThreeLabel.titleLabel?.textAlignment = NSTextAlignment.center
        aThreeLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        aFourLabel.titleLabel?.textAlignment = NSTextAlignment.center
        aFourLabel.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        // Sets the timer to 0
        timerProgressView.progress = 0.0
        
    }
    
    // As the view is shown to the user
    override func viewDidAppear(_ animated: Bool) {
        timerProgressView.trackTintColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        timerProgressView.progressTintColor = UIColor(red: 0.96, green:0.23, blue:0.34, alpha:1.0)
        
        //A new question will be set
        setNewQuesstion()
        questionProcess(index: currentQuestionIndex) // The question process will begin
    }
    
    func questionProcess(index: Int) {
        // Timer is rest
        timerLabel.text = "10"
        // A new timer begins, calling the updateProgress() function every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateProgress() {
        
        timeDelay -= 1 // Seconds count down by 1
        timerLabel.text = String(timeDelay)
        timerProgressView.progress += 0.1 // Timer gets closer to 10 seconds
        
        // Timer text changes colour as it gets closer to 0
        if String(timeDelay) == "1" || String(timeDelay) == "2" || String(timeDelay) == "3" {
            
            self.timerLabel.textColor = UIColor(red:0.96, green:0.23, blue:0.34, alpha:1.0)
            
        }
        
        // If the timer is up
        if timeDelay == 0 {
            
            timer.invalidate() // End the timer
            if questionChoice == questions[currentQuestionIndex].correctAnswer { // If the user has got the correct answer
                
                runningTotal += 1 // Add one to their total
                
            }
            questions.remove(at: currentQuestionIndex) // Remove the question from teh list to stop repeat
            if !questions.isEmpty { // If theres still questions left , reset everything
                timerLabel.textColor = UIColor.white
                timerProgressView.progress = 0.0
                timeDelay = 10
                questionNumber += 1
                resetButtonColours()
                setNewQuesstion()
                questionNumberLabel.fadeTransition(0.4)
                questionNumberLabel.text = "Question [\(questionNumber)/10]"
                questionProcess(index: currentQuestionIndex) // Recursion
            } else { // Theres no more questions left
                
                self.performSegue(withIdentifier: "showScoreSegue", sender: nil) // Show the end score screen
                
            }
            
        }
        
    }
    
    func resetButtonColours() {
        
        aOneLabel.backgroundColor = navy
        aTwoLabel.backgroundColor = navy
        aThreeLabel.backgroundColor = navy
        aFourLabel.backgroundColor = navy
        questionChoice = ""
        
    }
    
    func setNewQuesstion() {
        
        var answerButtons = [aOneLabel, aTwoLabel, aThreeLabel, aFourLabel] // Put labels into an array
        
        let randomQIndex = Int(arc4random_uniform(UInt32(questions.count))) // Get a random question index
        let currentQuestion = questions[randomQIndex] // Get a random question
        questionTitleLabel.fadeTransition(0.4)
        questionTitleLabel.text = currentQuestion.questionTitle // Set question title
        
        while answerButtons.count > 1 {

            let randomAIndex = Int(arc4random_uniform(UInt32(answerButtons.count))) // Get a random answer label
            let randomIncorrectAIndex = Int(arc4random_uniform(UInt32(currentQuestion.allAnswers.count))) // Get random answer
            answerButtons[randomAIndex]?.fadeTransition(0.4)
            answerButtons[randomAIndex]?.setTitle(currentQuestion.allAnswers[randomIncorrectAIndex], for: .normal) // Set the title for the buttons
            answerButtons.remove(at: randomAIndex) // Remove label from list
            // Once done, remove the answer from the list to stop reapeat answers
            currentQuestion.allAnswers.remove(at: randomIncorrectAIndex)
            
        }
        answerButtons[0]?.fadeTransition(0.4)
        answerButtons[0]?.setTitle(currentQuestion.correctAnswer, for: .normal) // Once all answers are set, set the correct answer
        
        currentQuestionIndex = randomQIndex // Set the global variable
    }

    // If any of these buttons are tapped, the answers in them are set globally
    
    @IBAction func oneLabelDidTap(_ sender: Any) {
        
        aOneLabel.backgroundColor = blue
        aTwoLabel.backgroundColor = navy
        aThreeLabel.backgroundColor = navy
        aFourLabel.backgroundColor = navy
        questionChoice = aOneLabel.titleLabel?.text as! String
        
    }
    
    @IBAction func twoLabelDidTap(_ sender: Any) {
        
        aOneLabel.backgroundColor = navy
        aTwoLabel.backgroundColor = blue
        aThreeLabel.backgroundColor = navy
        aFourLabel.backgroundColor = navy
        questionChoice = aTwoLabel.titleLabel?.text as! String
        
    }
    
    @IBAction func threeLabelDidTap(_ sender: Any) {
        
        aOneLabel.backgroundColor = navy
        aTwoLabel.backgroundColor = navy
        aThreeLabel.backgroundColor = blue
        aFourLabel.backgroundColor = navy
        questionChoice = aThreeLabel.titleLabel?.text as! String
    }
    
    @IBAction func fourLabelDidTap(_ sender: Any) {
        
        aOneLabel.backgroundColor = navy
        aTwoLabel.backgroundColor = navy
        aThreeLabel.backgroundColor = navy
        aFourLabel.backgroundColor = blue
        questionChoice = aFourLabel.titleLabel?.text as! String
    }
    
    // Preparation for the score showing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showScoreSegue" {
            
            let showScoreVC = segue.destination as! ShowScoreViewController
            
            showScoreVC.score = runningTotal // Will pass the final score to the view to be displayed
            
        }
        
        
        
    }
    
}
