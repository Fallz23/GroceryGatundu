//
//  Grocery.swift
//  GroceryGatundu
//
//  Created by JOSHUA GATUNDU on 2/5/26.
//

import Foundation
import Foundation
import SwiftUI
import FirebaseDatabase

class Grocery{
    var name = ""
    var count = 0
    var price = 0.0
    var ref = Database.database().reference()
    var key = ""
    
    init(name: String = "", count: Int = 0, price: Double = 0.0) {
        self.name = name
        self.count = count
        self.price = price
    }
    
    init(stuff: [String:Any]){
        if let n = stuff["name"] as? String{
            name = n
        }
        else{
            name = "John Doe"
        }
        
        if let a = stuff["count"] as? Int{
            count = a
        }
        else{
            count = 0
        }
        if let b = stuff["price"] as? Double{
            price = b
        }
        else{
            price = 0.0
        }
        var blah = stuff
    }
    func saveToFirebase(){
        // create dictionary
        let dict = ["name": name, "count":count, "price": price] as [String: Any]
        
        // saving dictionary to firebase
        ref.child("grocery2").childByAutoId().setValue(dict)
        //key = ref.child("students2").childByAutoId().key?? "0"
    }
    func deleteFromFirebase(){
        ref.child("students2").child(key).removeValue()
    }
    
}
