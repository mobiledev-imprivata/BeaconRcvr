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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        log("viewDidLoad")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.appendMessage(_:)), name: newMessageNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appendMessage(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let message = userInfo["message"] as? String else { return }
        let newText = textView.text + "\n" + message
        textView.text = newText
        textView.scrollRangeToVisible(NSRange(location: newText.characters.count, length: 0))
    }

}

