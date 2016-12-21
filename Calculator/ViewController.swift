//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Kim on 12/19/16.
//  Copyright © 2016 Alexander Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userInMiddleOfTyping = false
    var usingDotButton = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        //print("touched the \(digit) digit")
        if userInMiddleOfTyping {
            let textCurrent = display.text!
            display.text = textCurrent + digit
        } else {
            display.text = digit
        }
        userInMiddleOfTyping = true
    }

    @IBAction func usingDot(_ sender: UIButton) {
        if !usingDotButton {
            usingDotButton = true
            let textCurrent = display.text!
            display.text = textCurrent + "."
        }
    }

    @IBAction func performOperation(_ sender: UIButton) {
        userInMiddleOfTyping = false
        usingDotButton = false
        if let mathOp = sender.currentTitle {
            if mathOp == "π" {
                display.text = String(M_PI)
            }
        }
    }
}

