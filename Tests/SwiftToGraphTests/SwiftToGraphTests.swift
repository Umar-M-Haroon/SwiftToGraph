import XCTest
import SwiftSyntax
@testable import SwiftToGraph

final class SwiftToGraphTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftToGraph().text, "Hello, World!")
    }
    /*
     visited:  StructDeclSyntax visit(_:) 61 LiveScore
     tree begin
     visited:  FunctionDeclSyntax visit(_:) 112 removeNonStarting
     tree begin
     visited:  FunctionCallExprSyntax visit(_:) 173 removeAll
     tree begin
     visited:  FunctionCallExprSyntax visitPost(_:) 185 removeAll
     tree end
     visited:  FunctionCallExprSyntax visit(_:) 173 removeAll
     tree begin
     visited:  FunctionCallExprSyntax visitPost(_:) 185 removeAll
     tree end
     visited:  FunctionCallExprSyntax visit(_:) 173 removeAll
     tree begin
     visited:  FunctionCallExprSyntax visitPost(_:) 185 removeAll
     tree end
     visited:  FunctionCallExprSyntax visit(_:) 173 removeAll
     tree begin
     visited:  FunctionCallExprSyntax visitPost(_:) 185 removeAll
     tree end
     visited:  FunctionCallExprSyntax visit(_:) 173 removeAll
     tree begin
     visited:  FunctionCallExprSyntax visitPost(_:) 185 removeAll
     tree end
     visited:  FunctionDeclSyntax visitPost(_:) 123 removeNonStarting
     tree end
     visited:  FunctionDeclSyntax visit(_:) 112 removeOtherInfo
     tree begin
     visited:  FunctionCallExprSyntax visit(_:) 173 removeAll
     tree begin
     tree begin
     visited:  FunctionCallExprSyntax visit(_:) 173 contains
     tree begin
     visited:  FunctionCallExprSyntax visit(_:) 173 map
     tree begin
     visited:  FunctionCallExprSyntax visitPost(_:) 185 map
     tree end
     visited:  FunctionCallExprSyntax visitPost(_:) 185 contains
     tree end
     visited:  FunctionCallExprSyntax visitPost(_:) 185 removeAll
     tree end
     visited:  FunctionDeclSyntax visitPost(_:) 123 removeOtherInfo
     tree end
     visited:  StructDeclSyntax visitPost(_:) 72 LiveScore
     */
    func testSymbolTree() {
        var liveScore = Branch(parserNode: ParserNode(name: "LiveScore"))
        var removeNonStarting = Branch(parserNode: ParserNode(name: "removeNonStarting"))
        var removeAll: Branch = Branch(parserNode: ParserNode(name: "removeAll"))
        var removeOtherInfo = Branch(parserNode: ParserNode(name: "removeOtherInfo"))
        let map = Branch(parserNode: ParserNode(name: "map"))
        let contains = Branch(parserNode: ParserNode(name: "contains"))
        for branch in [removeAll, map, contains] {
            removeOtherInfo.addChild(branch)
        }
        for branch in [removeAll, removeAll, removeAll, removeAll, removeAll] {
            removeNonStarting.addChild(branch)
        }
        for branch in [removeOtherInfo, removeNonStarting] {
            liveScore.addChild(branch)
        }
        var root = Branch()
        root.addChild(liveScore)
        
        
//        let removeotherInfo = Branch()
//        let removeotherInfo = Branch()
//        let removeotherInfo = Branch()
//        let removeotherInfo = Branch()
//        let removeotherInfo = Branch()
//        let removeotherInfo = Branch()
//        let removeotherInfo = Branch()
//        tree begin StructDeclSyntax LiveScore
//        tree begin FunctionDeclSyntax removeNonStarting
//        tree begin FunctionCallExprSyntax removeAll
//        tree end FunctionCallExprSyntax removeAll
//        tree begin FunctionCallExprSyntax removeAll
//        tree end FunctionCallExprSyntax removeAll
//        tree begin FunctionCallExprSyntax removeAll
//        tree end FunctionCallExprSyntax removeAll
//        tree begin FunctionCallExprSyntax removeAll
//        tree end FunctionCallExprSyntax removeAll
//        tree begin FunctionCallExprSyntax removeAll
//        tree end FunctionCallExprSyntax removeAll
//        tree end FunctionDeclSyntax removeNonStarting
//        tree begin FunctionDeclSyntax removeOtherInfo
//        tree begin FunctionCallExprSyntax removeAll
//        tree begin FunctionCallExprSyntax contains
//        tree begin FunctionCallExprSyntax map
//        tree begin FunctionCallExprSyntax map
//        tree end FunctionCallExprSyntax contains
//        tree end FunctionCallExprSyntax removeAll
//        tree end FunctionDeclSyntax removeOtherInfo
//        tree end StructDeclSyntax LiveScore
    }
}
