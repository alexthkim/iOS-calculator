//
//  Code build from Stanford University's CS193P Class
//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alexander Kim on 12/20/16.
//  Copyright © 2016 Alexander Kim. All rights reserved.
//


import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var pending: PendingBinary?
    private var description = " "
    private var isPartialResult = true
    private var bigExpression = false
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    //dictionary of strings to their operations
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "±": Operation.UnaryOperation({ -$0 }),
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "tan": Operation.UnaryOperation(tan),
        "log": Operation.UnaryOperation(log10),
        "×": Operation.BinaryOperation(*),
        "+": Operation.BinaryOperation(+),
        "÷": Operation.BinaryOperation(/),
        "-": Operation.BinaryOperation(-), //subtraction has some rounding issues
        "^": Operation.BinaryOperation(pow),
        "=": Operation.Equals
    ]
    
    //enum for four different cases
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    //performs the operation and updates the two different displays
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                description = symbol
                accumulator = value
                isPartialResult = true
                bigExpression = false
            case .UnaryOperation(let function):
                description = symbol + "(\(description))"
                accumulator = function(accumulator)
                isPartialResult = true
                bigExpression = true
            case .BinaryOperation(let function):
                writePendingBinary()
                if !bigExpression {
                    description = "\(accumulator) " + symbol
                } else {
                    description = "(\(description)) " + symbol
                }
                excecutePendingBinary()
                pending = PendingBinary(binaryFunction: function,firstOperand: accumulator)
                isPartialResult = true
            case .Equals:
                writePendingBinary()
                excecutePendingBinary()
                isPartialResult = false
            }
        }
    }
    
    //executes the binary operation
    private func excecutePendingBinary() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    //writes the binary operation to the bottom display
    private func writePendingBinary() {
        if pending != nil {
            description += " \(accumulator)"
            bigExpression = true
        }
    }
    
    private struct PendingBinary {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as AnyObject
        }
        set {
            reset()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    }
                    if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }

    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    //returns a string value of the operations used to get the top display
    func finalWritingDisplay() -> String {
        if isPartialResult {
            return description + " ..."
        } else {
            return description + " ="
        }
    }
    
    //function that resets calculator on clear
    func reset() {
        accumulator = 0.0
        pending = nil
        description = " "
        isPartialResult = true
        bigExpression = false
        internalProgram.removeAll()
    }
}
