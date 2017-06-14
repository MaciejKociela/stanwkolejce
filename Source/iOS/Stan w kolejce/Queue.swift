//
//  Queue.swift
//  Stan w kolejce
//
//  Created by Marcin Kozłowski on 03.06.2017.
//  Copyright © 2017 Marcin Kozłowski. All rights reserved.
//

import Foundation

struct Queue {
    let id: Int
    let name: String
    var userNumber: Int
    
    init(id:Int, name:String, userNumber: Int) {
        self.id = id;
        self.name = name;
        self.userNumber = userNumber
    }
    
    mutating func changeNum(userNumber: Int) {
        self.userNumber = userNumber
    }
}
