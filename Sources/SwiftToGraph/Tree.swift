//
//  File.swift
//  
//
//  Created by Umar Haroon on 3/20/23.
//

import Foundation
import GraphKit
import SwiftSyntax
import OrderedCollections

struct Tree {
    init() {
        root = Branch()
        current = root
    }
    
    var root: Branch
    var current: Branch
    private(set) var graph: Graph = Graph(numberOfNodes: 0)
    
    mutating func visitPost() {
        current = current.parent ?? current
    }
    
    mutating func visitIfPossible() {
        if current.parent?.parserNode != nil {
            visitPost()
        }
    }
    
    mutating func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let new = Branch(parserNode: ParserNode(name: node.identifier.text, type: node.self))
        current.addChild(new)
        current = new
        return .visitChildren
    }
    
    mutating func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let node = Branch(parserNode: ParserNode(name: node.identifier.text, type: node.self))
        current.addChild(node)
        current = node
        return .visitChildren
    }
    
    mutating func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let node = Branch(parserNode: ParserNode(name: node.identifier.text, type: node.self))
        current.addChild(node)
        current = node
        return .visitChildren
    }
    
    mutating func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let funcCall = node.calledExpression.as(MemberAccessExprSyntax.self)?.name.text else { return .visitChildren }
        let node = Branch(parserNode: ParserNode(name: funcCall, type: node.self))
        current.addChild(node)
        current = node
        return .visitChildren
    }
    
    mutating func convertTreeToGraph() {
        var arrQueue: [Branch] = []
        var visited: OrderedSet<Branch> = []
        arrQueue.append(root)
        visited.append(root)
        while !arrQueue.isEmpty {
            let y = arrQueue.removeFirst()
            visited.append(y)
            if y.parserNode != nil {
                graph.addNode(node: y.parserNode)
                if let parentNode = y.parent?.parserNode {
                    graph.addDirectedEdge(u: parentNode.id, v: y.parserNode.id)
                }
            }
            for child in y.children {
                if !visited.contains(child) {
                    arrQueue.insert(child, at: 0)
                }
            }
        }
    }
}
