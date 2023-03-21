//
//  File.swift
//  
//
//  Created by Umar Haroon on 12/19/22.
//

import Foundation
import SwiftSyntax
import SwiftParser
import GraphKit
import Collections

public class SwiftParser: SyntaxVisitor {
    private var tree: Tree = Tree()
    
    func removeSystemFunctions(graph: Graph) {
        var graph = graph
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
        walk(Parser.parse(source: source))
        tree.convertTreeToGraph()
        return tree.graph
//        removeSystemFunctions()
    }

    /// Visiting `ClassDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        tree.visit(node)
    }
    
    /// The function called after visiting `ClassDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: ClassDeclSyntax) {
        tree.visitPost()
    }
    /// Visiting `StructDeclSyntax` specifically.
    ///   - Parameter node: the node we are visiting.
    ///   - Returns: how should we continue visiting.
    open override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        tree.visit(node)
    }
    
    /// The function called after visiting `StructDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: StructDeclSyntax) {
        tree.visitPost()
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
        tree.visit(node)
    }
    /// The function called after visiting `FunctionDeclSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: FunctionDeclSyntax) {
        tree.visitIfPossible()
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
        tree.visit(node)
    }
    
    /// The function called after visiting `FunctionCallExprSyntax` and its descendents.
    ///   - node: the node we just finished visiting.
    open override func visitPost(_ node: FunctionCallExprSyntax) {
        tree.visitIfPossible()
    }
    
}
