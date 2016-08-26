//
//  Sizes.swift
//  StandardSizes
//
//  Created by Deborah Engelmeyer on 8/26/16.
//  Copyright © 2016 The Inquisitive Introvert. All rights reserved.
//

import Foundation

public class Sizes {
    private let charts = ["baby", "child", "youth", "women", "men"]
    /// An array of keyed rows with the data for each size
    public var sizes = [[String: Double]]()
    private let root = "/Users/deb/Documents/workspace/StandardSizes/StandardSizes/StandardSizes/data"
    private let hipLength = ["baby" : 2.5, "child" : 5, "youth" : 10, "women" : 15, "men" : 10]
    
    public init() {
        for chart in charts {
            let fileContent = try? NSString(contentsOfFile: "\(root)/\(chart).csv", encoding: NSUTF8StringEncoding)
            let lines = fileContent!.componentsSeparatedByString("\r\n")
            var first = true
            var cols = [String]()
            for line in lines {
                let toks = line.componentsSeparatedByString(",")
                if (first) {
                    cols = toks
                    first = false
                } else {
                    var row:[String: Double] = [:]
                    for idx in 0 ... toks.count - 1 {
                        row[cols[idx]] = Double(toks[idx])
                    }
                    switch chart {
                    case "men":
                        row["Back Waist Length"] = row["Back Hip Length"]! - hipLength[chart]!
                    default:
                        row["Back Hip Length"] = row["Back Waist Length"]! + hipLength[chart]!
                    }
                    sizes.append(row)
                }
            }
        }
        calcSweaterAreas()
    }
    /* Calculate the area for a sweater for each size where the sweater
       has dropped shoulders and long sleeves.
       Use the following eases:
       Chest            Ease
        < 50cm          5cm
     50 <= size < 71cm  10cm
     71 <= size < 110   12.5cm
        >= 110          15cm */
    public func calcSweaterAreas() {
        let file = "sweaters.csv" //this is the file. we will write to and read from it
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            //writing
            do {
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }        let path = root.URLByAppendingPathComponent("")
        let text = "some text"
        
        //writing
        text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);

        for idx in 0..<sizes.count {
            var size = sizes[idx]
            let chest = eased(size["Chest"]!)
            let body = size["Back Hip Length"]! * chest
            let sleeves = chest * 0.75 * (size["Neck-to-Cuff"]! - chest)
            size["sweater-area"] = body + sleeves
            sizes[idx] = size
        }
    
    }
    
    private func eased(chest: Double) -> Double {
        var ease = 0.0
        switch chest {
        case 0 ..< 50:
            ease = 5
        case 50 ..< 71:
            ease = 10
        case 71 ..< 110:
            ease = 12.5
        default:
            ease = 15
        }
        return chest + ease
    }
}