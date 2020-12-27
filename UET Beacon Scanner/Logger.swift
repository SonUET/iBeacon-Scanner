//
//  Logger.swift
//  UET Beacon Scanner
//
//  Created by Duong Son on 12/6/17.
//  Copyright © 2017 Duong Son. All rights reserved.
//

import Foundation
func appendLog(s: String, fileName: String){
    let path = getDocumentsDirectory()
    let fileNameAndPath = path.appendingPathComponent(fileName)
    let fileAndPath = NSURL(fileURLWithPath: fileNameAndPath as String)
    
    var text = NSString()
    
    //reading
    do {
        text = try NSString(contentsOf: fileAndPath as URL, encoding: String.Encoding.utf8.rawValue)
    }
    catch { print("logfile read failed") }
    
    text = (text as String) + "\n" + s as NSString
    
    //writing
    do {
        try text.write(toFile: fileNameAndPath, atomically: true, encoding: String.Encoding.utf8.rawValue)
    }
    catch { print("logfile write failed") }
}

func quoteColumn(column: String) -> String {
//    if column.containsString(",") || column.containsString("\"") {
//        return "\"" + column.stringByReplacingOccurrencesOfString("\"", withString: "\"\"") + "\""
//    } else {
//        return column
//    }
    if column.contains(",") || column.contains("\""){
        return "\"" + column.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    } else {
        return column
    }
}

func commaSeparatedValueStringForColumns(columns: [String]) -> String {
    return columns.map {column in
        quoteColumn(column: column)
        }.joined(separator: ",")
}

func commaSeparatedValueDataForLines(lines: [[String]]) -> NSData {
    return lines.map { column in
        commaSeparatedValueStringForColumns(columns: column)
        }.joined(separator: "\r\n").data(using: String.Encoding.utf8)! as NSData
}

func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory as NSString
}
