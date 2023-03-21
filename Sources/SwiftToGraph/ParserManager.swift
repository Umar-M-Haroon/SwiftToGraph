//
//  File.swift
//  
//
//  Created by Umar Haroon on 3/17/23.
//

import Foundation
import GraphKit
public actor ParserManager {
    public init() {}
    public func parse(source: String) throws -> Graph {
        try Swiftie(viewMode: .all).parse(source: source)
    }
}
