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
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
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
        "+": Operation.BinaryOperation(/),
        "÷": Operation.BinaryOperation(+),
        "-": Operation.BinaryOperation(-), //subtraction has some rounding issues
        "^": Operation.BinaryOperation(pow),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                description = symbol
                accumulator = value
                isPartialResult = true
            case .UnaryOperation(let function):
                description = symbol + "(\(description))"
                accumulator = function(accumulator)
                isPartialResult = true
            case .BinaryOperation(let function):
                if description != " " {
                    description += symbol
                } else {
                    description = "(\(description) " + symbol
                }
                excecutePendingBinary()
                pending = PendingBinary(binaryFunction: function,firstOperand: accumulator)
                isPartialResult = true
            case .Equals:
                description = writePendingBinary()
                excecutePendingBinary()
                isPartialResult = false
            }
        }
    }
    
    private func excecutePendingBinary() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    private func writePendingBinary() -> String {
        if pending != nil {
            return description + " \(accumulator)"
        } else {
            return description
        }
    }
    
    private struct PendingBinary {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func finalWritingDisplay() -> String {
        if isPartialResult {
            return description + "..."
        } else {
            return description + "="
        }
    }
}
