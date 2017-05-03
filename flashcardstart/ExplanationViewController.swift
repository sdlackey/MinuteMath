//
//  ExplanationViewController.swift
//  flashcardstart
//
//  Created by Spencer Lackey on 4/23/17.
//  Copyright © 2017 Spencer Lackey. All rights reserved.
//

import UIKit
import AVFoundation

class ExplanationViewController: UIViewController {
    
    var rcvData: String!
    let synthesizer = AVSpeechSynthesizer()
    var problemCount = 0
    var uniquemp: [String] = []

    @IBOutlet weak var missedProblems: UITextField!
    @IBOutlet weak var firstExpression: UITextField!
    @IBOutlet weak var secondExpression: UITextField!
    @IBOutlet weak var answerf: UITextField!
    @IBOutlet weak var totalscore: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missedProblems.isUserInteractionEnabled = false
        missedProblems.accessibilityLabel = "Missed problems"
        totalscore.accessibilityLabel = "Total score"
        firstExpression.accessibilityLabel = "First expression"
        secondExpression.accessibilityLabel = "Second expression"
        answerf.accessibilityLabel = "Answer"
        firstExpression.isUserInteractionEnabled = false
        secondExpression.isUserInteractionEnabled = false
        answerf.isUserInteractionEnabled = false
        totalscore.isUserInteractionEnabled = false
        if (rcvData != nil){
   //    missedProblems.text = rcvData
        }
        else{
            missedProblems.text = "Not working"
        }
        parseuinput(rcvData)
 //       missedProblems.text = String(mp)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseuinput(_ input: String){
        var values = input.components(separatedBy: ";")
        let totscore = values[values.count-1]
        values.removeLast()
        print (totscore)
        
        totalscore.text = totscore
        let congrats = "Great job!  You scored a " + String(totscore) + ("!")
        let spokenprob = AVSpeechUtterance(string: congrats)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
       // synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        
        if values.isEmpty{
            let noMiss = "Wow you got every problem right!  Go back to the main menu and see if you can do it again!"
            let spokenNo = AVSpeechUtterance(string: noMiss)
            spokenNo.voice = AVSpeechSynthesisVoice(language: "en-US")
    //        spokenNo.rate = 0.5
            synthesizer.speak(spokenNo)
        }
        else{
        uniquemp = Array(Set(values))
        var missedp = ""
            for element in uniquemp{
                missedp = missedp + element + "; "
            }
        missedProblems.text = missedp
            
    /*    print (uniquemp)
        var count = 0
        for element in uniquemp{        //removing the empty string "" from the array
            if (element == ""){
                uniquemp.remove(at: count)
            }
            count = count + 1
        }
        print (uniquemp)    */
        print (uniquemp)
        getProblems(uniquemp)
  //      return uniquemp
        }
    }
    
    func getProblems(_ input: Array<String>){
        var problems = input
     //   problems.removeLast()
        print(problems)
/*        for element in problems{
            print("Element in probs " + element)
            explainProblems(element)
        }   */
        explainProblems(problems[problemCount])
        problemCount += 1
        
    }
    
    func explainProblems(_ input: String){
        if input.contains("+"){
            print("input.contains " + input)
            eadd(input)
        }
        else if input.contains("-"){
            esub(input)
        }
        else if input.contains("*"){
            emult(input)
        }
        else if input.contains("/"){
            ediv(input)
        }
    }
    
    func eadd(_ input: String){
        let problem = input
        var problems = problem.components(separatedBy: "+")
        let expression1 = Int(problems[0])
        let expression2 = Int(problems[1])
        firstExpression.text = problems[0]
        print(problems[0])
        let ex2 = "+" + problems[1]
     //   expr2.text = "+" problems[1]
        secondExpression.text = ex2
        print(problems[1])
        let answer = expression1! + expression2!
        let textanswer = "=" + String(answer)
        answerf.text = String(textanswer)
        let speech = "The answer to " + problems[0] + "plus " + problems[1] + "is " + String(answer)
        let spokenprob = AVSpeechUtterance(string: speech)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
        //synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)

    }
    
    func esub(_ input: String){
        let problem = input
        var problems = problem.components(separatedBy: "-")
        let expression1 = Int(problems[0])
        let expression2 = Int(problems[1])
        firstExpression.text = problems[0]
        print(problems[0])
        let ex2 = "-" + problems[1]
        //   expr2.text = "+" problems[1]
        secondExpression.text = ex2
        print(problems[1])
        let answer = expression1! - expression2!
        let textanswer = "=" + String(answer)
        answerf.text = String(textanswer)
        let speech = "The answer to " + problems[0] + "minus " + problems[1] + "is " + String(answer)
        let spokenprob = AVSpeechUtterance(string: speech)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
        //synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        
    }
    
    func emult(_ input: String){
        let problem = input
        var problems = problem.components(separatedBy: "*")
        let expression1 = Int(problems[0])
        let expression2 = Int(problems[1])
        firstExpression.text = problems[0]
        print(problems[0])
        let ex2 = "*" + problems[1]
        //   expr2.text = "+" problems[1]
        secondExpression.text = ex2
        print(problems[1])
        let answer = expression1! * expression2!
        let textanswer = "=" + String(answer)
        answerf.text = String(textanswer)
        let speech = "The answer to " + problems[0] + "times " + problems[1] + "is " + String(answer)
        let spokenprob = AVSpeechUtterance(string: speech)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
        //synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        
    }
    
    func ediv(_ input: String){
        let problem = input
        var problems = problem.components(separatedBy: "/")
        let expression1 = Int(problems[0])
        let expression2 = Int(problems[1])
        firstExpression.text = problems[0]
        print(problems[0])
        let ex2 = "/" + problems[1]
        //   expr2.text = "+" problems[1]
        secondExpression.text = ex2
        print(problems[1])
        let answer = expression1! / expression2!
        let textanswer = "=" + String(answer)
        answerf.text = String(textanswer)
        let speech = "The answer to " + problems[0] + "divided by " + problems[1] + "is " + String(answer)
        let spokenprob = AVSpeechUtterance(string: speech)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
        //synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        
    }
    
   
    @IBAction func NextProbClicked(_ sender: Any) {
        if(problemCount < uniquemp.count){
        explainProblems(uniquemp[problemCount])
            problemCount += 1
        }
        else{
            let speech = "That was all of the incorrect answers, hit the back to main menu button to play again!"
            let spokenprob = AVSpeechUtterance(string: speech)
            spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
            //synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(spokenprob)

            
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
