//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Philipp Sanktjohanser on 21.12.22.
//

import SwiftUI

struct ContentView: View {
//    @StateObject var order = Order()
    @StateObject var vm = OrderViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $vm.order.type) {
                        ForEach(OrderViewModel.Order.types.indices) {
                            Text(OrderViewModel.Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(vm.order.quantity)", value: $vm.order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $vm.order.specialRequestEnabled.animation())
                    
                    if vm.order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $vm.order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $vm.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView()
                            .environmentObject(vm)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
