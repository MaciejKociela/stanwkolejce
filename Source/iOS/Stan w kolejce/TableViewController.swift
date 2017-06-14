//
//  ViewController.swift
//  Stan w kolejce
//
//  Created by Marcin Kozłowski on 02/06/2017.
//  Copyright © 2017 Marcin Kozłowski. All rights reserved.
//

import UIKit
import SocketIO

class TableViewController: UITableViewController {
    let queueCellId = "QueueCell"
    var queues: [Queue] = []
    
    @IBOutlet var queuesTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.queuesTableView.tableFooterView = UIView()
        
        self.queuesTableView.delegate = self
        self.queuesTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewController.handleQueuesInitNotification(_:)), name: NSNotification.Name(rawValue: "queuesInitNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewController.handleQueuesUpdateNotification(_:)), name: NSNotification.Name(rawValue: "queuesUpdateNotification"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: queueCellId, for: indexPath)
        
        let row = (indexPath as NSIndexPath).row
        let queue = queues[row]
        
        cell.textLabel?.text = "\(queue.name)"
        cell.detailTextLabel?.text = "Czekający: \(queue.userNumber)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at:indexPath, animated: true)
        
        let queueName = queues[indexPath.row].name
        let userNumber = queues[indexPath.row].userNumber
        
        let alert = UIAlertController(title: "Stanąć w \(queueName)?", message: "Czekających: \(userNumber)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Tak", style: UIAlertActionStyle.default, handler: { action in
            SocketIOManager.sharedInstance.addUser(queueIndex: indexPath.row)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailViewController
            
            self.queues[indexPath.row].userNumber += 1
            self.queuesTableView.reloadData()
            
            newViewController.queueNumber = self.queues[indexPath.row].userNumber
            newViewController.queue = indexPath.row
            
            self.navigationController?.pushViewController(newViewController, animated: true)
            //self.present(newViewController, animated: true, completion: nil)`
        }))
        alert.addAction(UIAlertAction(title: "Nie", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleQueuesInitNotification(_ notification: Notification) {
        handleDataUpdate(inputData: notification.object, isInit: true);
    }
    
    func handleQueuesUpdateNotification(_ notification: Notification) {
        handleDataUpdate(inputData: notification.object);
    }
    
    func handleDataUpdate(inputData: Any?, isInit: Bool = false) {
        if(isInit) {
            if let data = inputData as? [String: Any],
                let queues = data["stanowisko"] as? [[String: Any]], let id = data["id"] as? [Int],
                let numUsers = data["numUsers"] as? [Int] {
                
                for (index, queueContainer) in queues.enumerated()	{
                    let queueId = queueContainer["id"] as! Int
                    let queueName = queueContainer["name"] as! String
                    let userNumber = id[index] - numUsers[index] - 1

                    let newQueue = Queue(id: queueId, name: queueName, userNumber: userNumber)
                    
                    var isNewQueue = true
                    
                    self.queues = self.queues.map({ queue -> Queue in
                        if queue.id == newQueue.id {
                            isNewQueue = false
                            return newQueue
                        }
                        
                        return queue
                    })
                    
                    if isNewQueue {
                        self.queues.append(newQueue)
                    }
                }
                self.queuesTableView.reloadData()
            }
        } else {
            if let data = inputData as? [String: Any],
                let id = data["id"] as? [Int], let numUsers = data["numUsers"] as? [Int] {
                
                for index in 0..<queues.count {
                    let userNb = id[index] - numUsers[index] - 1
                    
                    queues[index].changeNum(userNumber: userNb)
                }
                
                self.queuesTableView.reloadData()
            }
        }
    }
}

