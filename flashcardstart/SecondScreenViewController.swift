//
//  SecondScreenViewController.swift
//  flashcardstart
//
//  Created by Spencer Lackey on 4/4/17.
//  Copyright © 2017 Spencer Lackey. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@available(iOS 10.0, *)
class SecondViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    //MARK: Properties

    @IBOutlet weak var testfield: UITextField!      //Problem field
    @IBOutlet weak var answerfield: UITextField!
    @IBOutlet weak var correctfield: UITextField!
    @IBOutlet weak var submitbutton: UIButton!
    
    var passeddata: String!
    var addval = ""
    var subval = ""
    var mulval = ""
    var divval = ""
    var num1 = 1
    var num2 = ""
    var useranswer = ""
    var correctanswer = 1
    var missedanswers = ""
    var missedproblems = ""
    var scoreMultiplier = 0
    var totalscore = 0
    var retry = 0
    var timer = Timer()
    var gameTimer = Timer()
    var wrongprobs: Array<String>?
    var audioPlayer = AVAudioPlayer()
    var recordingSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    //let speechRecognizer = SFSpeechRecognizer()!
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var recordingCount = 0
 /*   var passedd : String {
        get{
            return passeddata
        }
        set{
            passeddata = newValue
        }
    }   */
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      view.wantsLayer = true
        testfield.isUserInteractionEnabled = false
        correctfield.isUserInteractionEnabled = false
        gameTimer = Timer.scheduledTimer(timeInterval: 60, target:self, selector: #selector(SecondViewController.gameTimerEnded), userInfo: nil, repeats: false)
        answerfield.keyboardType = UIKeyboardType.numberPad
        print("yep")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ding", ofType: "m4a")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
        print("for sure")
        do{
            recordingSoundPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "swoosh", ofType: "m4a")!))
            recordingSoundPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
        print("NOPE")
        
            controlloop()
        // Do any additional setup after loading the view, typically from a nib.
/*        let uvalues = parseuinput(passeddata)
        let probtype = getProblemTypes(uvalues)
        getProblem(probtype)    */

      //  let rannum = ranNuminRange(addval)
 //       let thenum = String(rannum)
  //      let len = probtype.count

        
    }
    
    func controlloop(){
        let uvalues = parseuinput(passeddata)
        let probtype = getProblemTypes(uvalues)
        answerfield.text = ""
        getProblem(probtype)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseuinput(_ input: String) ->Array<String>{
        let values = input.components(separatedBy: ";")
        addval = values[0]
        print (addval)
        subval = values[1]
        print (subval)
        mulval = values[2]
        print (mulval)
        divval = values[3]
        print (divval)
        return values
    }
    
    func ranNuminRange(_ input: Int) -> Int{
 //       let thenum = Int(input)!
        let randomnum = Int(arc4random_uniform(UInt32(input)))
        return randomnum

    }
    
    func getProblemTypes(_ input: Array<String>) ->Array<String>{
        var probtypes: [String] = []
        if Int(input[0]) > 0{
            probtypes.append("add")
            probtypes.append(input[0])
            scoreMultiplier = scoreMultiplier + Int(input[0])!
        }
        if Int(input[1]) > 0{
            probtypes.append("sub")
            probtypes.append(input[1])
            scoreMultiplier = scoreMultiplier + (2 * Int(input[1])!)
        }
        if Int(input[2]) > 0{
            probtypes.append("mul")
            probtypes.append(input[2])
            scoreMultiplier = scoreMultiplier + (3 * Int(input[2])!)
        }
        if Int(input[3]) > 0{
            probtypes.append("div")
            probtypes.append(input[3])
            scoreMultiplier = scoreMultiplier + (4 * Int(input[3])!)
        }
        return probtypes
    }
    
    func getProblem(_ input: Array<String>){
        let numofTypes = (input.count) / 2
        let curproblem = ranNuminRange(numofTypes)
        if input[curproblem * 2] == "add"{
            addition(input[curproblem*2+1])
        }
        else if input[curproblem * 2] == "sub"{
            subtraction(input[curproblem*2+1])
        }
        else if input[curproblem*2] == "mul"{
            multiplication(input[curproblem*2+1])
        }
        else if input[curproblem*2] == "div"{
            division(input[curproblem*2+1])
        }
        
    }
    
    func addition(_ input: String){
        let range = Int(input)!
        let num1 = ranNuminRange(range)
        let num2 = ranNuminRange(range)
        let problem = String(num1) + "+" + String(num2)
        correctanswer = num1 + num2
    
        let spokenprob = AVSpeechUtterance(string: problem)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
      //  let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        testfield.text = problem
    }
    func subtraction(_ input: String){
        let range = Int(input)!
        let num1 = ranNuminRange(range)
        let num2 = ranNuminRange(range)
        var problem = ""
        var spProblem = ""
        if(num1 >= num2){
            problem = String(num1) + "-" + String(num2)
            correctanswer = num1 - num2
            spProblem = String(num1) + "minus" + String(num2)
        }
        else{
            problem = String(num2) + "-" + String(num1)
            correctanswer = num2 - num1
            spProblem = String(num2) + "minus" + String(num1)
        }
        
        let spokenprob = AVSpeechUtterance(string: spProblem)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
 //       let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        testfield.text = problem
    }
    func multiplication(_ input: String){
        let range = Int(input)!
        let num1 = ranNuminRange(range)
        let num2 = ranNuminRange(range)
        let problem = String(num1) + "*" + String(num2)
        let spProblem = String(num1) + "times" + String(num2)
        correctanswer = num1 * num2
        
        let spokenprob = AVSpeechUtterance(string: spProblem)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
//        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        testfield.text = problem
    }
    func division(_ input: String){
        let range = Int(input)!
        var num1 = ranNuminRange(range)
        var num2 = ranNuminRange(range)
        if num1 == 0 {
            num1 = 1
        }
        if num2 == 0{
            num2 = 1
        }
        
        let num3 = num1 * num2
        let problem = String(num3) + "/" + String(num1)
        let spProblem = String(num3) + "divided by" + String(num1)
        correctanswer = num2
        
        let spokenprob = AVSpeechUtterance(string: spProblem)
        spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
  //      let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(spokenprob)
        testfield.text = problem
    }
    
/*    @IBAction func answerfieldchange(sender: UITextField) {
        useranswer = answerfield.text!
        print(useranswer)
        let uanswer = Int(useranswer)
        if uanswer == correctanswer{
            correctfield.text = "Correct!"
        }
        else{
            correctfield.text = "Try again"
        }
    }   */
    
    func checkStringtoInt(_ input: String) -> String{
        print ("yep")
        let trimmedString = input.trimmingCharacters(in: .whitespaces)
        print ("success")
        print (trimmedString + "scooooops")
        switch trimmedString {
            case "0":
                return "0"
            case "Zero":
                return "0"
            case "One":
                return "1"
            case "Two":
                return "2"
            case "To":
                return "2"
            case "Too":
                return "2"
            case "Three":
                return "3"
            case "Four":
                return "4"
            case "For":
                return "4"
            case "Five":
                return "5"
            case "Six":
                return "6"
            case "Seven":
                return "7"
            case "Eight":
                return "8"
            case "Ate":
                return "8"
            case "Nine":
                return "9"
            case "Ten":
                return "10"
            case "Eleven":
                return "11"
        default:
            return input
        }
        print ("scooops3333")
    }
    
    @IBAction func submitclicked(_ sender: UIButton) {
//     stopRecording()
        //   audioEngine.stop()
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        recordingCount = 0
        useranswer = answerfield.text!
        if(useranswer == ""){
            return
        }
        print(useranswer)
    //    var uanswer = Int(useranswer)

        var tempanswer = checkStringtoInt(useranswer)
        let uanswer = Int(tempanswer)
//        if uanswer! <= 0{
//            let tempanswer = checkStringtoInt(useranswer)
//            uanswer = Int(tempanswer)!
//        }
        if uanswer == correctanswer{
            correctfield.text = "Correct!"
            retry = 0
            totalscore = totalscore + scoreMultiplier
            if audioPlayer.isPlaying{
                audioPlayer.pause()
            }
            audioPlayer.currentTime = 0
            audioPlayer.play()
  //          view.backgroundColor = UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1)
            changeBackcolor()
            controlloop()
            
        }
        else if uanswer > correctanswer{
            correctfield.text = useranswer + " is too high"
            let spokenprob = AVSpeechUtterance(string: useranswer + " is too high")
            spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
//            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(spokenprob)

//            missedanswers += useranswer + " "
//            missedproblems += testfield.text! + ";"
            answerfield.text = ""
            if retry == 0{
  //          let mparray = missedproblems.components(separatedBy: " ")
  //          let uniquemp = Array(Set(mparray))
                retry = 1
            }
            else{
                missedproblems += testfield.text! + ";"
                retry = 0
                controlloop()
//            print (missedanswers)
//            print (uniquemp)
            }
        }
        else if uanswer < correctanswer{
            correctfield.text = useranswer + " is too low"
            let spokenprob = AVSpeechUtterance(string: useranswer + " is too low")
            spokenprob.voice = AVSpeechSynthesisVoice(language: "en-US")
 //           let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(spokenprob)

            missedanswers += useranswer + " "
            missedproblems += testfield.text! + ";"
            answerfield.text = ""
            if retry == 0{
 //           let mparray = missedproblems.components(separatedBy: " ")   //Move this stuff to next View, this is for testing.  Keep as string
 //           let uniquemp = Array(Set(mparray))
 //           wrongprobs = uniquemp
                
                retry = 1
            }
            else{
                missedproblems += testfield.text! + ";"
                retry = 0
                controlloop()
            }
 //-           print (missedanswers)
//            print (uniquemp)
        }
    }
    
    func recordAndRecognizeSpeech(){
        print("YEAAAA I MAKE IT HERE1111")
//        if audioEngine.isRunning{
//            cancelRecording()
//        }
        print("and here")
        guard let node = audioEngine.inputNode else{
            return
        }
        print("here too")
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            buffer, _ in self.request.append(buffer)
        }
      
        
        print("YEAAAA I MAKE IT HERE")
        audioEngine.mainMixerNode.outputVolume = 0.0
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch{
            return print(error)
        }
        
        print("YEAAAA I MAKE IT HERE22222")
        
        guard let myRecognizer = SFSpeechRecognizer() else{
                return      // A recognizer is not supported for the current locale
            }
        
        if !myRecognizer.isAvailable{
            return
        }
        
        print("YEAAAA I MAKE IT HERE3333")
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {result, error in
            if let result = result{
                let bestString = result.bestTranscription.formattedString
                self.answerfield.text = bestString
               self.stopRecording()
            } else if let error = error{
                print(error)
            }
        })
    }
 
/*    func startRecording() throws{
        let node = audioEngine.inputNode!
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){ (buffer, _) in self.request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        recognitionTask = speechRecognizer.recognitionTask(with: request){ /* ... */}
    } */
    func stopRecording(){
        audioEngine.inputNode?.removeTap(onBus: 0)
        audioEngine.stop()
        request.endAudio()
    }
    func cancelRecording(){
        audioEngine.stop()
        if let node = audioEngine.inputNode{
            node.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
        request.endAudio()
    }
  
    @IBAction func speechBpressed(_ sender: Any) {
 /*       if recordingSoundPlayer.isPlaying{
            recordingSoundPlayer.pause()
        }
        recordingSoundPlayer.currentTime = 0
        recordingSoundPlayer.play()
         
*/
  //      view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        if recordingCount == 0{
            view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        self.recordAndRecognizeSpeech()
        }
        recordingCount = 1
    }
    
    func changeBackcolor(){
        view.backgroundColor = UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1)
        timer = Timer.scheduledTimer(timeInterval: 4, target:self, selector: Selector("bcolor"), userInfo: nil, repeats: false)
    }
    func bcolor(){
        if view.backgroundColor == UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1){
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        }
    }
    
    func gameTimerEnded(){
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        missedproblems.append(String(totalscore))
        performSegue(withIdentifier: "svtoExplanation", sender: missedproblems)
//        print(totalscore)
//        correctfield.text = tempProblems
//        view.backgroundColor = UIColor(red: 190/255, green: 60/255, blue: 255/255, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "svtoExplanation"{
            if let toViewController = segue.destination as? ExplanationViewController{
                toViewController.rcvData = sender as! String
                
            }
        }
    }
    
    
}

