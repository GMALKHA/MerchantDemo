//
//  CardCheckoutView.swift
//  MerchantDemo
//
//  Created by Georgi Malkhasyan on 11/7/24.
//

import Foundation
import SwiftUI

struct CardCheckoutView: View {
    @State private var cardNumber: String = "4111111111111111"
    @State private var expiryDate: String = "12/26"
    @State private var cvv: String = "123"
    @State private var isProcessing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private let orderID = "56T31469W53047444"
    private let paymentManager = PayPalPaymentManager(accessToken: "A21AAJZm5w7kaXJpZ1aRvqlVydnbmacOZ7zR7WYfcOnW2qHOpJV5dve-Ui9drCBbiujo9J0EKv_LR6m9IYx75HqXPajAS6HlQ", intent: "CAPTURE")
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Card Number", text: $cardNumber)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            TextField("Expiry Date (MM/YY)", text: $expiryDate)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            SecureField("CVV", text: $cvv)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button(action: processPayment) {
                Text("Pay with Card")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .disabled(isProcessing || cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty)
            
            if isProcessing {
                ProgressView("Processing...")
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Payment Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func processPayment() {
        isProcessing = true
        
        paymentManager.approvePayment(orderID: orderID, cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvv) { result in
            DispatchQueue.main.async {
                self.isProcessing = false
                switch result {
                case .success(let message):
                    self.alertMessage = "Payment Successful: \(message)"
                case .failure(let error):
                    self.alertMessage = "Payment Failed: \(error.localizedDescription)"
                }
                self.showAlert = true
            }
        }
    }
}


struct CardCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CardCheckoutView()
    }
}

