//
//  ContentView.swift
//  PaymentCalculator
//
//  Created by bnewton on 2/7/22.
//

import SwiftUI

enum Field: Hashable {
    case vehicleSalesPrice
    case cashDownPayment
}

struct ContentView: View {
    
    @FocusState private var focusedField: Field?
    
    @State private var vehicleSalesPrice = 15_000.00
    @State private var interestRate = 6
    @State private var loanTerm = 60
    @State private var cashDownPayment = 0.00
    
    var amountFinanced: Double {
                
        let total = vehicleSalesPrice - cashDownPayment
        return total
    }
    
    var monthlyPayment: Double {
        
        let principal = amountFinanced
        var x: Double = 0.0
        
        if Double(interestRate) > 0.0{
            let rate = (Double(interestRate) / 100) / 12
            x = (rate * pow(1.00 + rate, Double(loanTerm))) / (pow(1.00 + rate, Double(loanTerm)) - 1)
            
            return Double(principal * x)
            
        } else {
            
            return (principal / Double(loanTerm))
        }
    }
    
    let loanTerms = [24, 36, 39, 42, 48, 60, 66, 72, 84]
    
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency{
        let currencyCode = Locale.current.currencyCode ?? "USD"
        
        return FloatingPointFormatStyle<Double>.Currency(code: currencyCode)
    }
    
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Vehicle Sales Price", value: $vehicleSalesPrice, format: currencyFormat)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .vehicleSalesPrice)
                        
                    Picker("Interest Rate", selection: $interestRate){
                        ForEach(0..<11){
                            Text("\($0)%")
                        }
                    }
                } header: {
                    Text("Vehicle Sales Price")
                }
                
              
                Section {
                    Picker("Loan Term", selection: $loanTerm){
                        ForEach(loanTerms, id: \.self){
                            Text("\($0) months")
                        }
                    }
                }
                
                Section {
                    TextField("Cash Down Payment", value: $cashDownPayment, format: currencyFormat)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .cashDownPayment)

                } header: {
                    Text("Cash Down Payment")
                }

                Section {
                    Text(amountFinanced, format: currencyFormat)
                } header: {
                    Text("Amount financed")
                }
                
                Section {
                    Text(monthlyPayment, format: currencyFormat)
                } header: {
                    Text("Estimated monthly car payment")
                }
                
                
            }.navigationTitle("Payment Calculator")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard){
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            ContentView()
        }
    }
}
