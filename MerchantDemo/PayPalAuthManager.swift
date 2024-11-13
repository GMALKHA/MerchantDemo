//
//  PayPalAuthManager.swift
//  MerchantDemo
//
//  Created by Malkhasyan, Georgi (624-Extern) on 11/7/24.
//

import Foundation
import CorePayments
import CardPayments

class PayPalPaymentManager: CardDelegate {
    
    private var coreConfig: CoreConfig
    private var cardClient: CardClient
    private var accessToken: String
    private var intent: String

    init(accessToken: String, intent: String) {
        self.accessToken = accessToken
        self.intent = intent
        
        coreConfig = CoreConfig(clientID: "AUv8rrc_P-EbP2E0mpb49BV7rFt3Usr-vdUZO8VGOnjRehGHBXkSzchr37SYF2GNdQFYSp72jh5QUhzG", environment: .sandbox)
        cardClient = CardClient(config: coreConfig)
        cardClient.delegate = self
    }
    
    // Step 1: Approve the payment using the orderID from Postman
    func approvePayment(orderID: String, cardNumber: String, expiryDate: String, cvv: String, completion: @escaping (Result<String, Error>) -> Void) {
        let components = expiryDate.split(separator: "/")
        guard components.count == 2 else {
            completion(.failure(NSError(domain: "Invalid expiry date format", code: 400, userInfo: nil)))
            return
        }
        
        let expirationMonth = String(components[0])
        let expirationYear = "20" + String(components[1])
        
        let card = Card(number: cardNumber, expirationMonth: expirationMonth, expirationYear: expirationYear, securityCode: cvv)
        let cardRequest = CardRequest(orderID: orderID, card: card, sca: .scaWhenRequired)
        
        cardClient.approveOrder(request: cardRequest)
    }
    
    private func captureOrder(orderID: String) {
        guard let url = URL(string: "https://api-m.sandbox.paypal.com/v2/checkout/orders/\(orderID)/capture") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestId = UUID().uuidString
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(requestId, forHTTPHeaderField: "7b92603e-77ed-4896-8e78-5dea2050476a")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error capturing payment: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to capture payment")
                return
            }
            
            print("Order successfully captured")
        }.resume()
    }
    
    private func authorizeOrder(orderID: String) {
            guard let url = URL(string: "https://api-m.sandbox.paypal.com/v2/checkout/orders/\(orderID)/authorize") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let requestId = UUID().uuidString
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(requestId, forHTTPHeaderField: "7b92603e-77ed-4896-8e78-5dea2050476a")
            request.setValue("return=representation", forHTTPHeaderField: "Prefer")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error authorizing payment: \(error.localizedDescription)")
                    return
                }
                print("Order successfully authorized")
            }.resume()
        }
    
    func card(_ cardClient: CardClient, didFinishWithResult result: CardResult) {
        print("Order Approved: \(result.orderID)")
        
        // Use the stored intent to determine if you should capture or authorize
        if intent == "AUTHORIZE" {
            authorizeOrder(orderID: result.orderID)
        } else if intent == "CAPTURE" {
            captureOrder(orderID: result.orderID)
        }
    }
    
    func card(_ cardClient: CardClient, didFinishWithError error: CoreSDKError) {
        print("Payment failed: \(error.localizedDescription)")
    }
    
    func cardDidCancel(_ cardClient: CardPayments.CardClient) {
        print("")
    }
    
    func cardThreeDSecureWillLaunch(_ cardClient: CardPayments.CardClient) {
        print("")
    }
    
    func cardThreeDSecureDidFinish(_ cardClient: CardPayments.CardClient) {
        print("")
    }
}
