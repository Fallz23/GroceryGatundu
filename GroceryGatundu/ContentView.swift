//
//  ContentView.swift
//  GroceryGatundu
//
//  Created by JOSHUA GATUNDU on 2/4/26.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase

struct ContentView: View {
    let  ref = Database.database().reference()
    @State var name = ""
    @State var count = ""
    @State var price = ""
    @State var names: [String] = []
    @State var grocerys: [Grocery] = []
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            TextField("Enter item", text: $name)
            TextField("Enter amount", text: $count)
            TextField("Enter price", text: $price)
            Button("Click"){
                if let b = Double(price){
                    if let a = Int(count){
                        let s = Grocery(name: name, count: a, price: b)
                        s.saveToFirebase()
                    }
                    
                }
                // names.append(name)
                //ref.child("students").childByAutoId().setValue(name)
                
            }
            List{//
                ForEach(grocerys, id: \.name){stud in
                    HStack{
                        Text("\(stud.name)")
                        Text("\(stud.count)")
                        Text("\(stud.price)")
                        //  n
                        Text("\(stud.key)")
                    }
                    
                }
                .padding()
                .onAppear(){
                    firebaseStuff()
                }
                
            }
            
            
        }
    }
        func firebaseStuff(){
            
            ref.child("grocery").observe(.childAdded, with: { (snapshot) in
                // snapshot is a dictionary with a key and a value
                
                // this gets each name from each snapshot
                let n = snapshot.value as! String
                // adds the name to an array if the name is not already there
                if !self.names.contains(n){
                    self.names.append(n)
                }
            })
            
            ref.child("grocery2").observe(.childAdded, with: { (snapshot) in
                // snapshot is a dictionary with a key and a value
                
                // this gets each name from each snapshot
                let d = snapshot.value as! [String:Any]
                let s = Grocery(stuff: d)
                s.key = snapshot.key
                
                // adds the name to an array if the name is not already there
                self.grocerys.append(s)
                
                
            })
            
        }
    
    
}

#Preview {
    ContentView()
}
