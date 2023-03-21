//
//  File.swift
//  
//
//  Created by Umar Haroon on 12/19/22.
//

import Foundation
import SwiftToGraph
import SwiftSyntax
import GraphKit
import OrderedCollections

@main
public struct ExampleApp {
    public static func main() throws {
        
        let source = """
        
        class A1 {
        
            static func parent() {
                BD.childFunc()
            }
            class A2 {
                static func childFunc() {
                    A1.parent()
                }
            }
        
        }
        
        """
    }
    
    static func combineFiles(files: [URL]) -> String {
        let allFiles: String = files
            .compactMap({ file in
                try? String(contentsOf: file)
            })
            .reduce("", +)
        return allFiles
    }
    
    static func parseSource(source: String) async throws -> String {
        var graph = try await ParserManager().parse(source: source)
        
//                    graph3.toGraphEditorSite().forEach({print("\($0)\n")})
        var highlightedEdges: OrderedSet<Edge> = []
        graph.nodes
            .compactMap({$0 as? ParserNode})
            .filter({$0.type is FunctionCallExprSyntax})
            .forEach { caller in
                guard let funcCallSyntax = caller.type as? FunctionCallExprSyntax else { return }
                let args = funcCallSyntax.argumentList.compactMap({$0.label?.description}).joined(separator: "")
                guard let v = graph.nodes
                    .compactMap({$0 as? ParserNode})
                    .filter({$0.type is FunctionDeclSyntax})
                    .first(where: { called in
                        guard let funcDeclSyntax = called.type as? FunctionDeclSyntax else { return false }
                        let params = funcDeclSyntax.signature.input.parameterList.compactMap({$0.firstName?.text}).joined(separator: "")
                        return args == params && called.name == caller.name
                    }) else { return }
                graph.addDirectedEdge(u: caller.id, v: v.id)
                //                    graph.removeNodeAndMoveEdges(id: caller.id, newV: v.id)
                graph.edges = OrderedSet(graph.edges.map { edge in
                    if edge.v == caller.id {
                        let newEdge = Edge(u: edge.u, v: v.id)
                        highlightedEdges.append(newEdge)
                        return newEdge
                    }
                    return edge
                })
                graph.removeNode(id: caller.id)
            }
        let graphEdges = graph.edges.subtracting(highlightedEdges)
        let views = graph.nodes.flatMap({NodeView(node: $0, attributes: [])})
        
        let edges = graphEdges.map({EdgeView(edge: $0, attributes: [], uDescription: graph[$0.u].description, vDescription: graph[$0.v].description)})
        let highlightedEdgeViews = highlightedEdges.map {
            EdgeView(edge: $0, attributes: [.init(key: EdgeAttributeKey.color, value: "pink"), .init(key: EdgeAttributeKey.label, value: "calls")], uDescription: graph[$0.u].description, vDescription: graph[$0.v].description)
        }
        let allViews: [any DOTView] = views + edges + highlightedEdgeViews
        let graphView = GraphView {
            allViews
        }
        return graphView.build().joined(separator: "\n")
    }
}
