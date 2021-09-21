//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Mehar on 07/09/2021.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}
class ResultViewController: UIViewController {
    
    

    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
  
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dialogView.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        //set the text
        titleLabel?.text = titleText
        feedbackLabel?.text = feedbackText
        dismissButton?.setTitle(buttonText, for: .normal)
        
        //Hide the UI Elements
        dimView.alpha = 0
        titleLabel?.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //fade in th elements
        UIView.animate(withDuration: 0.6, delay: 0, options:.curveEaseOut, animations: {
            self.dimView.alpha = 1
            self.titleLabel?.alpha  = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)

    }
    @IBAction func dismissTapped(_ sender: Any) {
        
        //Fade out the dim view and then dismiss the pop up
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.dimView.alpha = 0
        } completion: { completed in
           //dismiss the pop up
            self.dismiss(animated: true, completion: nil)
            //notify the delegate that popup was dismissed
            self.delegate?.dialogDismissed()
        }

        
    }

}
