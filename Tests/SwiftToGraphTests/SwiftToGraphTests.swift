import XCTest
import SwiftSyntax
import GraphKit
@testable import SwiftToGraph

final class SwiftToGraphTests: XCTestCase {

    func testSymbolTree() {
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
            let parser = SwiftParser()
            var graph3 = try parser.parse(source: source3)
            graph3.nodes.forEach({print("node:", $0.description)})
            graph3.edges.forEach({print("edge:", parser.graph[$0.u], "->", parser.graph[$0.v])})
            XCTAssertEqual(parser.graph.nodes.count, 16)
//            parser.addFunctionCalls()
            parser.removeSystemFunctions()
            print("-----------------------")
            XCTAssertEqual(parser.graph.nodes.count, 8)
            parser.graph.nodes.forEach({print("node:", $0.description)})
            parser.graph.edges.forEach({print("edge:", parser.graph[$0.u], "->", parser.graph[$0.v])})
            
            //            graph3.toGraphEditorSite().forEach({print("\($0)\n")})
//            let views = graph3.nodes.flatMap({NodeView(node: $0, attributes: [])})
//            let edges = graph3.edges.flatMap({EdgeView(edge: $0, attributes: [], uDescription: graph3[$0.u].description, vDescription: graph3[$0.v].description)})
//            let allViews: [any View] = views + edges
//            let graphView = GraphView {
//                allViews
//            }
//            print(graphView.build().joined(separator: "\n"))
        } catch let err {
            print(err)
        }
    }
}
