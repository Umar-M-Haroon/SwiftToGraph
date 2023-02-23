//
//  Scope.swift
//  SwiftToGraph
//
//  Created by Umar Haroon on 12/28/22.
//

import Foundation

/// Scope represents the current scope/namespace in swift source code and holds nested symbols within it.
/// Typically a scope starts with "{" and ends with "}"
struct Scope {
    /// Starts a new nested scope
    func startAddingNewBranch() {
        print("begin")
    }
    
    /// Ends the current scope by adding a new symbol to the scope tree.
    /// The children provided in the closure are the symbols in the scope to be ended
    func end() {
        print("end")
    }
}
