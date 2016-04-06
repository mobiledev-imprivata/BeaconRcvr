//
//  Logger.swift
//  BeaconRcvr
//
//  Created by Jay Tucker on 4/6/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import Foundation

let newMessageNotification = "com.imprivata.newMessage"

func timestamp() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
    return dateFormatter.stringFromDate(NSDate())
}

func log(message: String) {
    print("[\(timestamp())] \(message)")
    NSNotificationCenter.defaultCenter().postNotificationName(newMessageNotification, object: nil, userInfo: ["message": message])
}
