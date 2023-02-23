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
        self.description = name
    }
    
    public init(name: String) {
        self.name = name
        self.type = nil
        self.description = name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    public static func ==(lhs: ParserNode, rhs: ParserNode) -> Bool {
        return lhs.id == rhs.id
    }
}


//
//extension Graph {
//    public func toGraphEditorSite() -> [String] {
//        self.nodes.flatMap { node in
//            node.edges.compactMap { edge in
//                guard let u = self.nodes.first(where: {$0.id == edge.u}) as? ParserNode,
//                      let v = self.nodes.first(where: {$0.id == edge.v}) as? ParserNode else { return nil }
//                return "\(u.name) \(v.name)"
//            }
//        } + self.nodes.flatMap({ node in
//            return (node as? ParserNode)?.name
//        })
//    }
//}
