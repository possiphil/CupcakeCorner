//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Philipp Sanktjohanser on 21.12.22.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var vm: OrderViewModel
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    @State private var hasFinished = false
    @Environment(\.dismiss) var dismiss
//    let dismissClosure: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityElement()
                .accessibilityHidden(true)
                
                Text("Your total is \(vm.order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { dismiss() }
        } message: {
            Text(confirmationMessage)
        }
        .alert("Oops…!", isPresented: $showingErrorAlert) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(vm.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            errorMessage = "Checkout failed. \(error.localizedDescription)"
            showingErrorAlert = true
        }
    }
}

//struct CheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckoutView(order: Order())
//    }
//}
