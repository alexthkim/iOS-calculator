//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Kim on 12/19/16.
//  Copyright © 2016 Alexander Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userInMiddleOfTyping = false
    private var usingDotButton = false
    private var previousNumber = 0
    
    @IBAction private func touchDigit(_ sender: UIButton) {
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
    
    @IBAction private func usingDot(_ sender: UIButton) {
        if !usingDotButton {
            usingDotButton = true
            let textCurrent = display.text!
            display.text = textCurrent + "."
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userInMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userInMiddleOfTyping = false
        }
        
        if let mathOp = sender.currentTitle {
            brain.performOperation(symbol: mathOp)
        }
        displayValue = brain.result
    }
}

