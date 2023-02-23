//
//  File.swift
//  
//
//  Created by Umar Haroon on 12/19/22.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser
import GraphKit
import Collections
public class SwiftParser: SyntaxVisitor {
    var graph: Graph = Graph(numberOfNodes: 0)
//    private var tree: SymbolTree = SymbolTree()
    public override init() {
        root = Branch()
        current = root
    }
    var root: Branch
    var current: Branch
    func convertTreeToGraph(branch: Branch) {
        var arrQueue: [Branch] = []
        var visited: OrderedSet<Branch> = []
        arrQueue.append(branch)
        visited.append(branch)
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
                    arrQueue.append(child)
                }
            }
        }
    }
    
    func addFunctionCalls() {
        for node in graph.nodes where (node as? ParserNode)?.type is FunctionCallExprSyntax {
            if let caller = node as? ParserNode {
                if let decl: ParserNode = graph.nodes.first(where: { node -> Bool in
                    if let node = node as? ParserNode {
                        return node.type is FunctionDeclSyntax && node.name == caller.name
                    } else { return false }
                }) as? ParserNode {
                    if decl.description != caller.description {
                        graph.addUndirectedEdge(u: decl, v: caller)
                    }
                }
            }
        }
    }
    func removeSystemFunctions() {
        for n in graph.nodes {
            if let parserN = n as? ParserNode, parserN.type is FunctionCallExprSyntax {
                if !graph.nodes.contains(where: {
                    ($0 as? ParserNode)?.type is FunctionDeclSyntax && ($0 as? ParserNode)?.name == parserN.name}
                ) {
                    graph.removeNode(id: parserN.id)
                }
                
            }
        }
    }
    
    public func parse(source: String) throws -> Graph {
        walk(try SyntaxParser.parse(source: source))
        convertTreeToGraph(branch: root)
        addFunctionCalls()
        removeSystemFunctions()
        return graph
    }
    public func startScope() -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    
    /// Visiting `ClassDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let new = Branch(parserNode: ParserNode(name: node.identifier.text, type: node.self))
        current.addChild(new)
        current = new
        return .visitChildren
    }
    
    /// The function called after visiting `ClassDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: ClassDeclSyntax) {
        current = current.parent ?? current
//        scope.end { children in
//            let result = ParserNode(name: node.identifier.text, type: node.self)
//            graph.addNode(node: result)
//            children.forEach { child in
//                graph.addDirectedEdge(u: result.id, v: child.id)
//            }
//            return result
//        }
    }
    /// Visiting `StructDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let node = Branch(parserNode: ParserNode(name: node.identifier.text, type: node.self))
        current.addChild(node)
        current = node
        return .visitChildren
    }
    
    /// The function called after visiting `StructDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: StructDeclSyntax) {
//        print(node.identifier.text)
        current = current.parent ?? current
        //        SymbolHandler().visitComplete(node: node)
//        scope.end { children in
//            let result = ParserNode(name: node.identifier.text, type: node.self)
//            graph.addNode(node: result)
//            children.forEach { child in
//                graph.addDirectedEdge(u: result.id, v: child.id)
//            }
//            return result
//        }
    }
    /// Visiting `ProtocolDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    
    /// The function called after visiting `ProtocolDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: ProtocolDeclSyntax) {
    }
    /// Visiting `ExtensionDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    
    /// The function called after visiting `ExtensionDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: ExtensionDeclSyntax) {
    }
    // Visiting `ExtensionDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let node = Branch(parserNode: ParserNode(name: node.identifier.text, type: node.self))
        current.addChild(node)
        current = node
        return .visitChildren
    }
    /// The function called after visiting `FunctionDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: FunctionDeclSyntax) {
//        guard let funcCall = node.calledExpression.as(MemberAccessExprSyntax.self)?.name.text else { return }
        if current.parent?.parserNode != nil {
            current = current.parent ?? current
        }
//        tree.visitComplete()
//        scope.end { children in
//            let result = ParserNode(name: node.identifier.text, type: node.self)
//            graph.addNode(node: result)
//            children.forEach { child in
//                graph.addDirectedEdge(u: result.id, v: child.id)
//            }
//            return result
//        }
    }
    /// Visiting `InitializerDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    
    /// The function called after visiting `InitializerDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: InitializerDeclSyntax) {}
    /// Visiting `DeinitializerDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    
    /// The function called after visiting `DeinitializerDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: DeinitializerDeclSyntax) {}
    /// Visiting `SubscriptDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    
    
    open override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    
    /// The function called after visiting `EnumDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: EnumDeclSyntax) {}
    
    /// Visiting `FunctionCallExprSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard let funcCall = node.calledExpression.as(MemberAccessExprSyntax.self)?.name.text else { return .visitChildren }
        let node = Branch(parserNode: ParserNode(name: funcCall, type: node.self))
        current.addChild(node)
        current = node
        return .visitChildren
    }
    
    /// The function called after visiting `FunctionCallExprSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: FunctionCallExprSyntax) {
//        current = current.parent ?? current
        if current.parent?.parserNode != nil {
            current = current.parent ?? current
        }
    }
    
}
