//
//  ViewController.swift
//  QuizApp
//
//  Created by Mehar on 02/09/2021.
//

import UIKit

class ViewController: UIViewController,QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewLeadingConstraint:
        NSLayoutConstraint!
    
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog:ResultViewController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inistialise the result dialog
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        //set up tableview deletegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //set up model
        model.delegate = self
        model.getQuestions()
        
        
    }
    
    
    func displayQuestion(){
        
        guard questions.count > 0 && currentQuestionIndex < questions.count else{
            return
        }
        //Display the question text
        questionLabel.text = questions[currentQuestionIndex].question
        let text = questions[currentQuestionIndex].question
          print(text)
   
        //reload the answer table
        tableView.reloadData()
        
        //slide in question
        slideInQuestion()
    }
    
    
//MARK: - QUIZ PROTOCOL METHODS
    
    func questionsRetrieved(_ questions: [Question]) {
       
        print("Questions retrieved from model!")
        
        self.questions = questions
        
        //check if we shoukd restore the state before showing question #1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
       
        if savedIndex != nil && savedIndex! < self.questions.count{
            
            //set the current questin to the saved index
            currentQuestionIndex = savedIndex!
            
            //retrieve the number correct from storage
           let  savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil{
                numCorrect = savedNumCorrect!
                
            }
            
        }
        
        // Display the firts question
        displayQuestion()
        
       
        
    }
    
    //MARK: - TavleView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure that questions array is not empty
       
        guard questions.count > 0 else{
            return 0
        }
        
        //return number of answeres of the current question
        
        let currentQuestion = questions[currentQuestionIndex]
        if currentQuestion.answers != nil{
            return currentQuestion.answers!.count
        }else{
            return 0
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
    
        //Customize the cell
        let label =  cell.viewWithTag(1) as? UILabel
        
        if label != nil{
           //TODO: set label text
            
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                label?.text = question.answers![indexPath.row]
                
            }
        }
        //return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        var titleText = ""
        
        //user has tapped the row,check if its right
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex == indexPath.row{
            print("user got it right")
            titleText = "Correct!"
            numCorrect += 1
            
        }else{
            print("user got it wrong")
            titleText = "Wrong!"
        }
        //show the pop up
        if resultDialog != nil{
            
            //cutomise the pop up model
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
            
        }
        
        
    }
//MARK: - ResultViewControllerProtocol Methods
    
    func dialogDismissed() {
        
        //Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        if questions.count == currentQuestionIndex{
            //user just answered the last question
            //show the pop up
            if resultDialog != nil{
                
                //cutomise the pop up model
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You answere \(numCorrect) questions correct out of \(questions.count)"
                resultDialog!.buttonText = "Restart"
                present(resultDialog!, animated: true, completion: nil)
            }
            
            //clear the state
            StateManager.clearState()
            
        }else if currentQuestionIndex > questions.count {
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        }
        else if currentQuestionIndex < questions.count {
            //we have more questions to display
            
            //display the next question
            displayQuestion()
            
           
            
            //save the state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
       
    }
    
    func slideOutQuestion(){
        
        //set teh initial state
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        rootStackView.alpha = 1
        view.layoutIfNeeded()
        
        //animate it to the end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewTrailingConstraint.constant = 1000
            self.stackViewLeadingConstraint.constant = -1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
    }
    func slideInQuestion(){
        
        //set teh initial state
        stackViewLeadingConstraint.constant = -1000
        stackViewTrailingConstraint.constant = 1000
        rootStackView.alpha = 0
        view.layoutIfNeeded()
        
        //animate it to the end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewTrailingConstraint.constant = 0
            self.stackViewLeadingConstraint.constant = 0
            self.rootStackView.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
}

