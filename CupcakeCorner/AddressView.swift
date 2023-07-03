//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Philipp Sanktjohanser on 21.12.22.
//

import SwiftUI

struct AddressView: View {
    @EnvironmentObject var vm: OrderViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $vm.order.name)
                TextField("Street address", text: $vm.order.streetAddress)
                TextField("City", text: $vm.order.city)
                TextField("Zip", text: $vm.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView()
                } label: {
                    Text("Check out")
                }
            }
            .disabled(vm.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView()
        }
        .environmentObject(OrderViewModel())
    }
}
