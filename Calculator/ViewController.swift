//
//  Code build from Stanford University's CS193P Class
//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Kim on 12/19/16.
//  Copyright © 2016 Alexander Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //shows the top display
    @IBOutlet private weak var display: UILabel!
    
    //shows the operations used to get the top display
    @IBOutlet private weak var displayOrder: UILabel!
    
    private var userInMiddleOfTyping = false
    private var usingDotButton = false
    private var previousNumber = 0
    private var brain = CalculatorBrain()
    
    //gives functionality to pressing a digit button
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
    
    //gives functionality to pressing the dot button
    @IBAction private func usingDot(_ sender: UIButton) {
        if !usingDotButton {
            usingDotButton = true
            let textCurrent = display.text!
            display.text = textCurrent + "."
        }
    }
    
    //variable to representing a value
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    //gives functionality to pressing the C (clear) button
    @IBAction func clearAll(_ sender: UIButton) {
        display.text = "0"
        displayOrder.text = "0"
        userInMiddleOfTyping = false
        brain.reset()
    }
    
    //gives functionality to pressing an operation button
    @IBAction private func performOperation(_ sender: UIButton) {
        usingDotButton = false
        if userInMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userInMiddleOfTyping = false
        }
        
        if let mathOp = sender.currentTitle {
            brain.performOperation(symbol: mathOp)
            displayOrder.text = brain.finalWritingDisplay()
        }
        displayValue = brain.result
    }
}

