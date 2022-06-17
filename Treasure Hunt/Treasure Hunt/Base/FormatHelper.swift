//
//  FormatHelper.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 17.06.2022.
//

import Foundation

class FormatHelper: NSObject {
    class func formatMinuteSeconds(_ totalSeconds: Int) -> String {
        var returnTime = ""
        hmsFrom(seconds: totalSeconds) { hours, minutes, seconds in
            
            let minutes = getStringFrom(seconds: minutes)
            let seconds = getStringFrom(seconds: seconds)
            
            returnTime = "\(minutes):\(seconds)"
        }
        return returnTime
    }
    
    private class func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private class func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}

