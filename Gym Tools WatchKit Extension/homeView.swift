//
//  homeView.swift
//  Gym Tools WatchKit Extension
//
//  Created by Samuele Lo Truglio on 12/09/21.
//

import SwiftUI

struct homeView: View {
    @State var counter : Int
    var body: some View {
        
        ZStack( alignment: .trailing, content: {
            
            Button(action: {
                print(counter);
                if(counter < 10){
                    counter+=1
                }
            }, label: {
                Text("\(counter)")
                    .font(.largeTitle)
                    .lineLimit(1)
                    .frame(width: 100.0, height: 100.0)
                    
            }).clipShape(Circle())
            
            Button(action: {
                print("rosso")
                counter = 0
            }, label: {
                Image(systemName: "delete")
                    .foregroundColor(Color.white)
                    .frame(width: 40, height: 40)
            }).buttonStyle(PlainButtonStyle())
            .background(Color.red)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
            
            .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .topLeading)
            
            
            
            
            Button(action: {
                print("grigio")
            }, label: {
                Image(systemName: "master")
                    .frame(width: 40, height: 40)
            }).buttonStyle(PlainButtonStyle())
            .background(Color.gray)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
            
            .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .bottomTrailing)
            
        })
        
    }
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        
        homeView(counter: 0)
    }
}
