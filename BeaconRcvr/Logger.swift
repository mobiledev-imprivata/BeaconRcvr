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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
    return dateFormatter.string(from: Date())
}

func log(_ message: String) {
    print("[\(timestamp())] \(message)")
    NotificationCenter.default.post(name: Notification.Name(rawValue: newMessageNotification), object: nil, userInfo: ["message": message])
}
