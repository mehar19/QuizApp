//
//  QuizModel.swift
//  QuizApp
//
//  Created by Mehar on 02/09/2021.
//

import Foundation

protocol QuizProtocol {
    
    func questionsRetrieved(_ questions:[Question])
    
}
class QuizModel{
    
    var delegate:QuizProtocol?
    
    func getQuestions(){
       
      //  getLocalJSonFile()
        getRemoteJSonFile()
        
        
        
    }
    func getLocalJSonFile(){
        
        //Get bundle path to json file
        let path = Bundle.main.path(forResource: "QuestionData", ofType: ".json")
         
        //Double check if the isn't nil
        guard path != nil else {
            print("Couldn't find the json data file")
            return
        }
        
        //Create URL object from the path
        let url  = URL(fileURLWithPath: path!)
        
        do{
            //Get the data from URL
            let data = try Data(contentsOf: url)
            
            //Try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try
                decoder.decode([Question].self, from: data)
           
            //Notify the delegate of the oarsed objects
            delegate?.questionsRetrieved(array)
            
            
            
        }
        catch{
            
        }
    }
    
    func  getRemoteJSonFile(){
        
        //Get the URL object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        guard url != nil else{
            print("Couldn't create the URL object")
            return
        }
        
        //Get a URL Session object
        let session = URLSession.shared
        
        //Get a task object
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            //check that there wasn't an error
            if error == nil && data != nil{
                
                do{
                    //create a JSon decoder object
                    let decoder = JSONDecoder()
                    //parse the json
                    let array = try decoder.decode([Question].self, from: data!)
                    
                    //Use the main thread to notify the view cobtroller for UI Work
                    DispatchQueue.main.async {
                        
                        //notify the delagate of the parsed objects
                        self.delegate?.questionsRetrieved(array)
                    }
                    
                }catch{
                    // Error: Couldnt download the data at that URL
                    print("Couldn't parse JSON")
                }
            }
            
        }
        
        //call the resume on the data task
        dataTask.resume()
    }
}
