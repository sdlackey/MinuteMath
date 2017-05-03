//
//  ViewController.swift
//  flashcardstart
//
//  Created by Spencer Lackey on 3/21/17.
//  Copyright © 2017 Spencer Lackey. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class HomeViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var addselector: UISegmentedControl!
    @IBOutlet weak var addrange: UITextField!
    @IBOutlet weak var subselector: UISegmentedControl!
    @IBOutlet weak var subrange: UITextField!
    @IBOutlet weak var mulselector: UISegmentedControl!
    @IBOutlet weak var mulrange: UITextField!
    @IBOutlet weak var divselector: UISegmentedControl!
    @IBOutlet weak var divrange: UITextField!
    @IBOutlet weak var startb: UIButton!
    
    var addsel = "yes"
    var subsel = "yes"
    var mulsel = "yes"
    var divsel = "yes"
   // var passdata: [Int] = []
    var passdata = ""
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("View has loaded")
      //  addselector.accessibilityHint = "Addition selector"
        addselector.accessibilityLabel = "Addition selector"
        addselector.setTitle("Include addition", forSegmentAt: 0)
        addselector.setTitle("No addition", forSegmentAt: 1)
        subselector.accessibilityHint = "Subtraction selector"
        mulselector.accessibilityHint = "Multiplication selector"
        divselector.accessibilityHint = "Division selector"
 //       addrange.accessibilityHint = "Addition range"
        addrange.accessibilityLabel = "Addition range"
        subrange.accessibilityLabel = "Subtraction range"
        divrange.accessibilityLabel = "Division range"
        mulrange.accessibilityLabel = "Multiplication range"
        mulselector.selectedSegmentIndex = 1
        divselector.selectedSegmentIndex = 1
        addrange.keyboardType = UIKeyboardType.numberPad
        subrange.keyboardType = UIKeyboardType.numberPad
        mulrange.keyboardType = UIKeyboardType.numberPad
        divrange.keyboardType = UIKeyboardType.numberPad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startbpressed(_ sender: AnyObject) {
 //       passdata = [addrange.text!, subrange.text!, mulrange.text!, divrange.text!]
        
                if addrange.text?.isEmpty == false{
            passdata = addrange.text!
        }
        passdata += ";"
        if subrange.text?.isEmpty == false{
            passdata += subrange.text!
        }
        passdata += ";"
        if mulrange.text?.isEmpty == false{
            passdata += mulrange.text!
        }
        passdata += ";"
        if divrange.text?.isEmpty == false{
            passdata += divrange.text!
        }   
   //     let passdata = addrange.text! + ";" + subrange.text! + ";" + mulrange.text! + ";" + divrange.text!
        performSegue(withIdentifier: "hometosecond", sender: passdata)
 //       self.performSegueWithIdentifier("SecondViewSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hometosecond"{
            if let toViewController = segue.destination as? SecondViewController{
                toViewController.passeddata = sender as! String
                
            }
    }
    }

    @IBAction func addsegvalchange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            addsel = "yes"
            addrange.text = "10"
        case 1:
            addsel = "no"
            addrange.text = "0"
        default:
            break
        }
    }

    @IBAction func subselvalchange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            subsel = "yes"
            subrange.text = "10"
        case 1:
            subsel = "no"
            subrange.text = "0"
        default:
            break
        }
    }

    @IBAction func mulselvalchange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            mulsel = "yes"
            mulrange.text = "10"
        case 1:
            mulsel = "no"
            mulrange.text = "0"
        default:
            break
        }
    }

    @IBAction func divselvalchange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            divsel = "yes"
            divrange.text = "10"
        case 1:
            divsel = "no"
            divrange.text = "0"
        default:
            break
        }
    }
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func howtoClicked(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUp") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination2 = segue.destination as? SecondScreenViewController{
            
            if let name = sender as? String{
                destination2.passeddata = name
            }
        }
    }   */
    
/*   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination2 = segue.destinationViewController as? SecondViewController{
            if let name = sender as? String{
                destination2.passeddata = name
            }
        }
    }
*/
    
    
}

