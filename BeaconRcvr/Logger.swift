//
//  Logger.swift
//  BeaconRcvr
//
//  Created by Jay Tucker on 4/6/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import Foundation

let newMessageNotification = "com.imprivata.newMessage"

private var dateFormatter: DateFormatter = {
    let dt = DateFormatter()
    dt.dateFormat = "HH:mm:ss.SSS"
    return dt
}()

func log(_ message: String) {
    let timestamp = dateFormatter.string(from: Date())
    print("[\(timestamp)] \(message)")
    NotificationCenter.default.post(name: Notification.Name(rawValue: newMessageNotification), object: nil, userInfo: ["message": message])
}
