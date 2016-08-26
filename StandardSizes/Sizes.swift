//
//  Sizes.swift
//  StandardSizes
//
//  Created by Deborah Engelmeyer on 8/26/16.
//  Copyright © 2016 The Inquisitive Introvert. All rights reserved.
//

import Foundation

public class Sizes {
    private let paths = ["baby.csv", "child.csv", "youth.csv", "women.csv", "men.csv"]
    /// An array of keyed rows with the data for each size
    public var sizes = [[String: String]]()
    private let root = "/Users/deb/Documents/workspace/StandardSizes/StandardSizes/StandardSizes/data"
    
    public init() {
        for path in paths {
            let fileContent = try? NSString(contentsOfFile: "\(root)/\(path)", encoding: NSUTF8StringEncoding)
            let lines = fileContent!.componentsSeparatedByString("\r\n")
            var first = true
            var cols = [String]()
            for line in lines {
                let toks = line.componentsSeparatedByString(",")
                if (first) {
                    cols = toks
                    first = false
                } else {
                    var row:[String: String] = [:]
                    for idx in 0 ... toks.count - 1 {
                        row[cols[idx]] = toks[idx]
                    }
                    sizes.append(row)
                }
            }
        }
    }
}