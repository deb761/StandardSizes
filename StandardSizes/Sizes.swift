//
//  Sizes.swift
//  StandardSizes
//
//  Created by Deborah Engelmeyer on 8/26/16.
//  Copyright © 2016 The Inquisitive Introvert. All rights reserved.
//

import Foundation
import Cocoa

public class Sizes {
    private let charts = ["Baby", "Child", "Youth", "Women", "Men"]
    /// An array of keyed rows with the data for each size
    public var sizes = [[String: Double]]()
    private let hipLength = ["Baby" : 2.5, "Child" : 5, "Youth" : 10, "Women" : 15, "Men" : 10]
    
    public init() {
        for chart in charts {
            
            var status = ""
            guard let asset = NSDataAsset(name: chart) else {
                status = "Could not find the data"
                return
            }
        
            let options = [
                NSDocumentTypeDocumentAttribute : NSPlainTextDocumentType,
                NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding
                ] as [String : AnyObject]
            
            var fileContent:NSAttributedString?
            do {
                fileContent = try NSAttributedString(data: asset.data, options: options, documentAttributes: nil)
            } catch let err{
                status = "Error = \(err)"
            }
        
            let lines = fileContent?.string.componentsSeparatedByString("\r\n")
            var first = true
            var cols = [String]()
            for line in lines! {
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
                    case "Men":
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
        for idx in 0..<sizes.count {
            var size = sizes[idx]
            let chest = eased(size["Chest"]!)
            let body = size["Back Hip Length"]! * chest
            let sleeves = chest * 0.75 * (size["Neck-to-Cuff"]! - chest)
            size["sweater-area"] = body + sleeves
            size["vest-area"] = body
            sizes[idx] = size
        }
        
    }
    
    /* Save the sweater and vest areas to a file */
    public func saveAreas(url:NSURL) {
        let hdr = "Chest,Sweater,Vest\r\n"
        do {
            try hdr.writeToURL(url, atomically: false, encoding: NSUTF8StringEncoding)
            for size in sizes {
            let str = "\(size["Chest"]!),\(size["sweater-area"]!),\(size["vest-area"]!)"
            try str.appendLineToURL(url)
        }
        
        } catch let error as NSError {
            let myPopup = NSAlert(error: error)
            myPopup.runModal()
        }
    }
    
    /* Calculate the finished chest size for a sweater or vest */
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