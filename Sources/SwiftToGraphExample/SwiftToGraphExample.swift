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
//        do {
//            let graph = try SwiftParser().parse(source: source)
//            print(graph.toGraphEditorSite())
//        } catch let err {
//            print(err)
//        }
//
        let source2 = """
public struct Node: GraphNode {
    public var id = UUID()
    public var edges: OrderedSet<Edge>
    init(id: UUID, edges: OrderedSet<Edge>) {
        self.id = id
        self.edges = edges
    }
    public init() {
        self.edges = []
    }
    public func degree() -> Int {
        return edges.count
    }
}
public struct Edge: Equatable, Hashable {
    /// first node id
    public var u: UUID
    /// second node id
    public var v: UUID
    
    public init(u: UUID, v: UUID) {
        self.u = u
        self.v = v
    }
    
    public func reverse() -> Edge {
        return Edge(u: v, v: u)
    }
}
public struct Graph {
    internal init(nodes: [any GraphNode]) {
        self.nodes = nodes
    }
    
    public private(set) var nodes: [any GraphNode]
    public var edges: OrderedSet<Edge> {
        var e: OrderedSet<Edge> = []
        nodes.forEach({ node in
            node.edges.forEach({ edge in
                e.append(edge)
            })
        })
        return e
    }
    public init(numberOfNodes: Int) {
        var totalNodes: [Node] = []
        var dict: [Int: Node] = [:]
        for i in 0 ..< numberOfNodes {
            let n = Node(id: UUID(), edges: [])
            totalNodes.append(n)
            dict[i] = n
        }
        self.nodes = totalNodes
    }
    mutating public func addDirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}) else { return }
        let edge = Edge(u: u, v: v)
        mutableNodes[uIndex].edges.append(edge)
        self.nodes = mutableNodes
    }
    mutating public func removeDirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}) else { return }
        mutableNodes[uIndex].edges.removeAll(where: {$0.v == v})
        self.nodes = mutableNodes
    }
    mutating public func removeUndirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}),
        let vIndex = self.nodes.firstIndex(where: {$0.id == v}) else { return }
        mutableNodes[uIndex].edges.removeAll(where: {$0.v == v})
        mutableNodes[vIndex].edges.removeAll(where: {$0.v == u})
        self.nodes = mutableNodes
    }
    mutating public func addUndirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}),
              let vIndex = self.nodes.firstIndex(where: {$0.id == v}) else { return }
        let edge = Edge(u: u, v: v)
        mutableNodes[uIndex].edges.append(edge)
        mutableNodes[vIndex].edges.append(edge.reverse())
        self.nodes = mutableNodes
    }
    
    mutating public func addNode(node: any GraphNode = Node()) {
        var mutableNodes = self.nodes
        mutableNodes.append(node)
        self.nodes = mutableNodes
    }
    mutating public func removeNode(id: UUID) {
        var mutableNodes = self.nodes
        mutableNodes.removeAll(where: {$0.id == id})
        self.nodes = mutableNodes
    }
    /// bfs search
    /// - Returns:
    func bfs(start: UUID) -> OrderedSet<UUID> {
        var arrQueue: [UUID] = []
        var visited: OrderedSet<UUID> = []
        arrQueue.append(start)
        visited.append(start)
        while !arrQueue.isEmpty {
            let y = arrQueue.removeFirst()
            visited.append(y)
            for edge in self.edges where edge.u == y || edge.v == y {
                if !visited.contains(edge.v) {
                    arrQueue.insert(edge.v, at: arrQueue.count)
                }
            }
        }
        return visited
    }
    
//    func dfs(start: Int, visited: [Int] = []) -> OrderedSet<Int> {
//        var vis = visited
//        vis.append(start)
//        return self.dfs(start: <#T##Int#>, visited: vis)
//    }
}
"""
//        do {
//            var graph2 = try SwiftParser().parse(source: source2)
//            print(graph2.edges.count)
//            for n in graph2.nodes {
//                if let parserN = n as? ParserNode, parserN.type is FunctionCallExprSyntax {
//                    if !graph2.nodes.contains(where: {
//                        ($0 as? ParserNode)?.type is FunctionDeclSyntax && ($0 as? ParserNode)?.name == parserN.name}
//                    ) {
//                        graph2.removeNode(id: parserN.id)
//                    }
//
//                }
//            }
//            graph2.toGraphEditorSite().forEach({print("\($0)\n")})
//        } catch let err {
//            print(err)
//        }
        
        let source3 = """
public struct LiveScore: Codable, Equatable {
    public init(nba: LiveEvent? = nil, mlb: LiveEvent? = nil, soccer: LiveEvent? = nil, nfl: LiveEvent? = nil, nhl: LiveEvent? = nil) {
        self.nba = nba
        self.mlb = mlb
        self.soccer = soccer
        self.nfl = nfl
        self.nhl = nhl
    }
    
    public var nba: LiveEvent?
    public var mlb: LiveEvent?
    public var soccer: LiveEvent?
    public var nfl: LiveEvent?
    public var nhl: LiveEvent?
    
    mutating public func removeNonStarting() {
        nba?.events.removeAll(where: { event in
            event.hasDoneStatus
        })
        mlb?.events.removeAll(where: { event in
            event.hasDoneStatus
        })
        soccer?.events.removeAll(where: { event in
            event.hasDoneStatus
        })
        nfl?.events.removeAll(where: { event in
            event.hasDoneStatus
        })
        nhl?.events.removeAll(where: { event in
            event.hasDoneStatus
        })
    }
    mutating public func removeStuff() {
        self.removeOtherInfo()
        self.removeNonStarting()
    }
public func test() {
self.removeStuff()
}
    mutating public func removeOtherInfo() {
        soccer?.events.removeAll(where: { event in
            guard let idLeague = event.idLeague,
                  let leagueID = Int(idLeague) else { return true }
            return !Leagues.allCases.map({$0.rawValue}).contains(leagueID)
        })
        
    }
}
"""
        
        do {
            var graph3 = try SwiftParser().parse(source: source3)
            
//            graph3.toGraphEditorSite().forEach({print("\($0)\n")})
            let views = graph3.nodes.flatMap({NodeView(node: $0, attributes: [])})
            let edges = graph3.edges.flatMap({EdgeView(edge: $0, attributes: [], uDescription: graph3[$0.u].description, vDescription: graph3[$0.v].description)})
            let allViews: [any View] = views + edges
            let graphView = GraphView {
                allViews
            }
            print(graphView.build().joined(separator: "\n"))
        } catch let err {
            print(err)
        }
        
 
//        do {
//            let graph3 = try SwiftParser().parse(source: source3)
//            graph3.toGraphEditorSite().forEach({print("\($0)\n")})
//        } catch let err {
//            print(err)
//        }
//
//        let symbols = try SymbolParser.parse(source: source)
//            .flattened()
//            .compactMap { $0 as? InheritingSymbol }
//
//        dump(symbols)
//
//        let path = "~/Repositories/myProject" as NSString
//        let directoryURL = URL(fileURLWithPath: path.expandingTildeInPath)
//
//        let allSymbols = try FileManager.default
//            .enumerator(at: directoryURL, includingPropertiesForKeys: nil)?
//            .compactMap { $0 as? URL }
//            .filter { $0.hasDirectoryPath == false }
//            .filter { $0.pathExtension == "swift" }
//            .flatMap { try SymbolParser.parse(source: String(contentsOf: $0)) }
//
//        dump(allSymbols)
        
    }
}

// MARK: - Custom Visitor

//class MyProjectVisitor: SymbolParser {
//
//    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
//        startScope()
//    }
//
//    override func visitPost(_ node: StructDeclSyntax) {
//        guard let genericWhereClause = node.genericWhereClause else {
//            super.visitPost(node)
//            return
//        }
//
//        endScopeAndAddSymbol { children in
//            MySpecialStruct(
//                name: node.identifier.text,
//                children: children,
//                genericWhereClause: genericWhereClause.description
//            )
//        }
//    }
//}
//
//struct MySpecialStruct: Symbol {
//    let name: String
//    let children: [Symbol]
//    let genericWhereClause: String
//}
//
//// MARK: - FileManager convenience
//
//extension FileManager {
//    public func filesInDirectory(_ directoryURL: URL) -> [URL] {
//        guard let enumerator = enumerator(at: directoryURL, includingPropertiesForKeys: []) else {
//            return []
//        }
//
//        return enumerator
//            .compactMap { $0 as? URL }
//            .filter { $0.hasDirectoryPath == false }
//    }
//}
