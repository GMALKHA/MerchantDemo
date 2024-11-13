//
//  HomeView.swift
//  MerchantDemo
//
//  Created by Georgi Malkhasyan on 11/7/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Pay with PayPal Button
                NavigationLink(destination: PayPalCheckoutView()) {
                    Text("Pay with PayPal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Pay with Card Button
                NavigationLink(destination: CardCheckoutView()) {
                    Text("Pay with Card")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Checkout")
        }
    }
}


struct PayPalCheckoutView: View {
    var body: some View {
        Text("PayPal Checkout")
            .font(.title)
            .navigationTitle("PayPal")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
