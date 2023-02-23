//
//  File.swift
//  
//
//  Created by Umar Haroon on 12/26/22.
//

import Foundation
import SwiftSyntax
class Branch: Hashable, Equatable {
    static func == (lhs: Branch, rhs: Branch) -> Bool {
        lhs.children == rhs.children && lhs.parserNode == rhs.parserNode
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(children)
        hasher.combine(parserNode)
    }
    
    internal init(children: [Branch] = [], parserNode: ParserNode? = nil, parent: Branch? = nil) {
        self.children = children
        self.parserNode = parserNode
        self.parent = parent
    }
    
    var children: [Branch] = []
    var parserNode: ParserNode!
    weak var parent: Branch?
//    mutating func setNode(node: ParserNode) {
//        self.parserNode = node
//    }
    func addChild(_ node: Branch) {
        children.append(node)
        node.parent = self
    }
}

extension Branch: CustomDebugStringConvertible {
    var debugDescription: String {
        var string = ""
        for child in children {
            string.append(child.parserNode.debugDescription)
        }
        return string
    }
}
//struct SymbolTree {
//    var root: [Branch] = []
//    mutating func start() {
//        root.append(Branch())
//    }
//    
//   mutating  func visitComplete() {
//        root.append(Branch())
//    }
//}
