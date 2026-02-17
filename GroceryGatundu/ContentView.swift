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
    let ref = Database.database().reference()
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
            }

            // if they have the same name it will change both
            //switched to .key
            List{
                ForEach(grocerys, id: \.key){ stud in
                    HStack{
                        Text("\(stud.name)")
                        Text("\(stud.count)")
                        Text("\(stud.price)")
                    }
                    .swipeActions{

                        Button("delete"){
                            stud.deleteFromFirebase()
                        }

                        // updates variables
                        Button("Change"){
                            if let b = Double(price), let a = Int(count) {
                                stud.name = name
                                stud.count = a
                                stud.price = b
                                stud.updateFirebase()
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear(){
                firebaseStuff()
            }
        }
    }

    func firebaseStuff(){

        ref.child("grocery").observe(.childAdded, with: { snapshot in
            let n = snapshot.value as! String
            if !self.names.contains(n){
                self.names.append(n)
            }
        })

        ref.child("grocery2").observe(.childAdded, with: { snapshot in
            let d = snapshot.value as! [String:Any]
            let s = Grocery(stuff: d)
            s.key = snapshot.key
            self.grocerys.append(s)
        })

        ref.child("grocery2").observe(.childRemoved, with: { snapshot in
            let k = snapshot.key

            for i in 0..<grocerys.count{
                if grocerys[i].key == k{
                    grocerys.remove(at: i)
                    break
                }
            }
        })

        ref.child("grocery2").observe(.childChanged) { snapshot in
            print("hi")

            let k = snapshot.key
            let d = snapshot.value as! [String:Any]

            let updated = Grocery(stuff: d)
            updated.key = k

            for i in 0..<grocerys.count {
                if grocerys[i].key == k {
                    grocerys[i] = updated
                    break
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
