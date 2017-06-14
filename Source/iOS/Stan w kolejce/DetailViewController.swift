//
//  DetailViewController.swift
//  Stan w kolejce
//
//  Created by Marcin Kozłowski on 04.06.2017.
//  Copyright © 2017 Marcin Kozłowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var mainText: UILabel!
    @IBOutlet var codeText: UILabel!
    
    var queue = 0
    var queueNumber = 0
    var code = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.handleGetNumberNotification(_:)), name: NSNotification.Name(rawValue: "queueGetNumberNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.handleQueuesUpdateNotification(_:)), name: NSNotification.Name(rawValue: "queuesUpdateNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleQueuesUpdateNotification(_ notification: Notification) {
        if let data = notification.object as? [String: Any],
            let id = data["id"] as? [Int], let numUsers = data["numUsers"] as? [Int] {
            
            let overallQueueUsers = id[queue] - numUsers[queue] - 1
            let currentQueueUser = queueNumber - numUsers[queue]
            
            print(overallQueueUsers)
            print(currentQueueUser)
            
            if(currentQueueUser < 1) {
                mainText.text = "Twoja kolej"
                codeText.text = ""
            } else {
                mainText.text = "Jesteś \(currentQueueUser) w kolejce"
            }
        }
    }
    
    
    func handleGetNumberNotification(_ notification: Notification) {
        if let data = notification.object as? [String: Any],
            let codes = data["code"] as? [[Any]], let id = data["id"] as? [Int],
            let numUsers = data["numUsers"] as? [Int] {
            
            queueNumber = id[queue] - 1
            let actualQueueNum = id[queue] - numUsers[queue] - 1
            
            code = codes[queue][queueNumber] as! Int
            
            mainText.text = "Jesteś \(actualQueueNum) w kolejce"
            codeText.text = "Twój kod: \(code)"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
