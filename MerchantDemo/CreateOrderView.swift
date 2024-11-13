//
//  CreateOrderView.swift
//  MerchantDemo
//
//  Created by Malkhasyan, Georgi (624-Extern) on 11/7/24.
//

import SwiftUI
import CardPayments

struct CreateOrderView: View {
    @State private var accessToken: String = ""
    @State private var amount: String = ""
    @State private var isProcessing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var orderId: String?
    @State private var navigateToPayment: Bool = false

    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
            }) {
                Text("Create Order")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isProcessing || amount.isEmpty)
            
            if isProcessing {
                ProgressView("Creating Order...")
                    .padding()
            }
            
            NavigationLink(
                destination: CardCheckoutView(),
                isActive: $navigateToPayment,
                label: { EmptyView() }
            )
        }
        .padding()
        .navigationTitle("Create Order")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Order Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
}

struct CreateOrderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateOrderView()
    }
}
