//
//  ContentView.swift
//  Gym Tools WatchKit Extension
//
//  Created by Samuele Lo Truglio on 08/09/21.
//

import SwiftUI

struct ContentView: View {
    @State var count: Int = 0
    var body: some View {
        VStack(content: {
            HStack( spacing: 0.0, content: {
                Text("\(count)")
                    .font(.largeTitle)
                    .frame(width: 100, height: 50.0)
                    
                Button(action: {
                    self.count += 1
                }, label: {
                    Text("+")
                })
                .padding(.leading, 5.0)
                .colorMultiply(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
            })
            
            Button(action: {
                self.count = 0
            }, label: {
                Text("Clear")
            })
            .padding(.vertical)
            .colorMultiply(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
            
            Text("120 s")
                .font(.title2)
                
                
        })
        .padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
