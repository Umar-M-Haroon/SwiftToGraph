//
//  ParserGraph.swift
//  
//
//  Created by Umar Haroon on 12/23/22.
//

import Foundation
import GraphKit
import Collections
import SwiftSyntax
public struct ParserNode: GraphNode {
    public var description: String
    
    public var id = UUID()
    public var name: String
    public var type: (any SyntaxHashable)?
    

    public init(name: String, type: any SyntaxHashable) {
        self.name = name
        self.type = type
        if let n = type as? FunctionDeclSyntax {
            self.description = name + n.signature.description
        } else if let node = type as? FunctionCallExprSyntax {
            self.description = name + node.description
        } else {
            self.description = name
        }
    }
    
    public init(name: String) {
        self.name = name
        self.type = nil
        self.description = name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(type?._syntaxNode)
    }
    
    public static func ==(lhs: ParserNode, rhs: ParserNode) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ParserNode: CustomStringConvertible {}


extension Graph {
    public mutating func removeNodeAndMoveEdges(id: UUID, newV: UUID) {
        self.edges = OrderedSet(self.edges.map { edge in
            if edge.v == id {
                let newEdge = Edge(u: edge.u, v: newV)
                return newEdge
            }
            return edge
        })
        removeNode(id: id)
    }
}
