//
//  Question.swift
//  QuizApp
//
//  Created by Mehar on 02/09/2021.
//

import Foundation

struct Question:Codable{
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
    
}
