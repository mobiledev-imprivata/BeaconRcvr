//
//  ViewController.swift
//  BeaconRcvr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        log("viewDidLoad")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appendMessage(_:)), name: NSNotification.Name(rawValue: newMessageNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func appendMessage(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let message = userInfo["message"] as? String else { return }
        let newText = textView.text + "\n" + message
        textView.text = newText
        textView.scrollRangeToVisible(NSRange(location: newText.characters.count, length: 0))
    }

}

