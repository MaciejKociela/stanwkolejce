import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "https://stanwkolejce-maciekkociela.c9users.io:8080")!, config: [.log(false), .forcePolling(true)])
    
    override init() {
        super.init()
        
        socket.on("connectionShop") { dataArray, ack in
            print("connectionShop")
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "queuesInitNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("changeNum") { dataArray, ack in
            print("changeNum")
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "queueGetNumberNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("changeNumBroad") { dataArray, ack in
            print("changeNumBroad")
            
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "queuesUpdateNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addUser(queueIndex: Int) {
        socket.emit("setIn", "\(queueIndex)")
    }
}
