//
//  ViewController.swift
//  HotelBot
//
//  Created by Aayush Kala on 09/07/18.
//  Copyright © 2018 Aayush Kala. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var response: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messageField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
     request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        // We haven’t initiated the request to API.AI. To do that, we call the enqueue method and specify the request
        ApiAI.shared().enqueue(request)
        messageField.text = ""
    }
    
    
    
    //We need to import the AVFoundation framework because we want our bot to talk to the user. The framework comes with the AVSpeechSynthesizer class which is capable to produce synthesized speech from text. To get our device to talk to our users, insert the following lines of code in the ViewController class:
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.response.text = text
        }, completion: nil)
    }
    
    //Let me tell you what the above lines of code perform. First, we begin by defining a constant speechSynthesizer and initiate an instance of AVSpeechSynthesizer. AVSpeechSynthesizer is an object that provides speech from a text and gives you access to control over ongoing access. Then we create a new function, speechAndText(text: String), to perform changes based on whatever the user inputs.
}


