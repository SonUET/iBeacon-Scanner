//
//  dataLogger.swift
//  UET Beacon Scanner
//
//  Created by Duong Son on 12/6/17.
//  Copyright © 2017 Duong Son. All rights reserved.
//

import Foundation

class dataLogger{
    var attributes: [String] = []
    private var startTime: NSDate?
    private let timestampKey = "timestamp"
    private var data: [[String: String]] = []
    
    init(attributeNames attributes: [String]) {
        self.attributes = [timestampKey]
        self.attributes += attributes
        self.data = [[String: String]]()
    }
    func start() {
        if self.startTime == nil {
            self.startTime = NSDate()
        }
    }
    func log(data: [[String:String]]) -> Bool{
        if let sTime = self.startTime{
            let timeDiff = NSDate().timeIntervalSince(sTime as Date)
            for d in data{
                var dataRecord = [String: String]()
                dataRecord.updateValue("\(timeDiff)", forKey: timestampKey)
                for key in d.keys{
                    if !self.attributes.filter({a in a == key }).isEmpty && key != timestampKey {
                        dataRecord.updateValue(d[key]!, forKey: key)
                    } else {return false}
            }
                self.data.append(dataRecord)
        }
            return true
        } else {
            return false
        }
    }
    func save(dataStoragePath path: String, error: NSErrorPointer) {
        let deliminator = ","
        let linebreak = "\n"
        
        var content: String = ""
        
        
        // attributes
        for attribute in self.attributes {
            content += "\(attribute)"
            
            if attribute == self.attributes.last {
                content += linebreak
            } else {
                content += deliminator
            }
        }
        
        for dataRecord in self.data {
            
            for attribute in self.attributes {
                
                content += "\(dataRecord[attribute]!)"
                
                if attribute == self.attributes.last {
                    content += linebreak
                } else {
                    content += deliminator
                }
            }
        }
        //content.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        //content.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: error)
    }
    func convertAbsoluteDateToRelativeDate(date: NSDate) -> TimeInterval{
        return date.timeIntervalSince(self.startTime! as Date)
    }
}
