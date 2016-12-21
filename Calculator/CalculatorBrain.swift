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
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation(*),
        "=": Operation.Equals
    ]
    
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function): pending = PendingBinary(binaryFunction: function,firstOperand: accumulator)
            case .Equals:
                if pending != nil {
                    accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
                    pending = nil
                }
            }
        }
    }
    
    struct PendingBinary {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
