//
//  File.swift
//  
//
//  Created by Umar Haroon on 3/17/23.
//

import Foundation
import GraphKit
actor ParserManager {
    func parseString(string: String) throws -> Graph {
        let parser = SwiftParser()
        return try parser.parse(source: string)
    }
}
