// xcode: set sdk=iOS

//
//  NumberPadView.swift
//  Passcode
//
//  Created by Sharif on 12/11/26.
//
import SwiftUI
struct NumberPadView :View {
    /// SF Symbol for the biometry button; `nil` hides the button.
    var biometrySymbolName: String? = nil
    var onBiometryTapped: () -> Void = {}
    var onDigitTapped: (Int) -> Void
    var onDeleteTapped: () -> Void
   private let columns:[GridItem]=[
        . init(),
        . init(),
        . init(),
        
    ]
    var  body: some View {
        LazyVGrid(columns: columns){
            ForEach(1 ... 9,id:\.self){
                index in Button{
                    onDigitTapped(index)
                }label: {
                    Text("\(index)").font(.title).frame(maxWidth: .infinity).padding(.vertical,16).contentShape(.rect)
                }
                
            }
            if let biometrySymbolName {
                Button{
                    onBiometryTapped()
                }label: {
                    Image(systemName: biometrySymbolName).font(.title).frame(maxWidth: .infinity).padding(.vertical,16).contentShape(.rect)
                }
                .accessibilityLabel("Unlock with biometrics")
            } else {
                // Keeps 0 centered under 8 when there's no biometry button.
                Color.clear
            }
            Button{
                onDigitTapped(0)
           }label: {
               Text("0").font(.title).frame(maxWidth: .infinity).padding(.vertical,16).contentShape(.rect)
           }
            Button{
             onDeleteTapped()
           }label: {
               Image(systemName: "delete.backward").font(.title).frame(maxWidth: .infinity).padding(.vertical,16).contentShape(.rect)
           }
           .accessibilityLabel("Delete")
        }.foregroundStyle(.primary)
    }
}

#Preview{
    NumberPadView(biometrySymbolName: "faceid", onDigitTapped: { _ in }, onDeleteTapped: {})
}
