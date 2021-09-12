//
//  ContentView.swift
//  Gym Tools WatchKit Extension
//
//  Created by Samuele Lo Truglio on 08/09/21.
//

import SwiftUI


var wrist : Int = WKInterfaceDevice.current().wristLocation.rawValue

var session: WKExtendedRuntimeSession!

func startSession() {
    session = WKExtendedRuntimeSession()
    session.start()
}

func stopSession() {
    session.invalidate()
    
}

struct GreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0.5, blue: 0))
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}

struct CustomTimeView: View {
    @Binding var time: Int
    @Binding var alarm : Bool
    @Binding var showSelf: Bool
    @Binding var timeViewOn : Bool
    
    @State private var selectedItem = "1"
    
    var times = (1...100).map { "\($0)" }
    var body: some View{
        VStack (content: {
            Picker(selection: $selectedItem, label: Text("Seconds"), content: {
                ForEach(times, id: \.self){ item in
                    Text(item)
                    
                }
            })
            Button(action: {
                time = Int(self.selectedItem) ?? 0
                alarm = true
                self.timeViewOn = false
                self.showSelf = false
            }, label: {
                Text("Confirm")
            }).buttonStyle(GreenButton())
            
        }).navigationTitle("Custom")

    }
}

struct TimeView: View{
    @Binding var timeRemaining : Int
    @Binding var alarm : Bool
    @Binding var timeViewOn : Bool
    @State var showCustom = false
    let data = [10,70,80,90,100,120].map { "\($0)" }
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View{
        
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(data, id: \.self) { item in
                            Button(item){
                                timeRemaining = Int(item) ?? 0
                                alarm = true
                                self.timeViewOn = false
                            }
                            .padding(.horizontal, 2.0)
                        }
                    }
                    .padding(.horizontal)

                NavigationLink(
                    destination: CustomTimeView(time: $timeRemaining, alarm: $alarm, showSelf: $showCustom, timeViewOn: $timeViewOn),
                    isActive: $showCustom,
                    label: {
                        Text("Custom")
                    })
                    .lineSpacing(20)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
        }
        .navigationTitle("Time")
    }
}

struct ContentView: View {
    
    @State var count: Int = 0
    @State var timeRemaining = 0
    @State var timerOn = false
    @State var timeView = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .center, content: {
            HStack( alignment: VerticalAlignment.center, spacing: 0.0, content: {
                if(wrist == 1){
                    
                    if(count > 0){
                        Button(action: {
                            self.count = 0
                        }, label: {
                            Image(systemName: "trash")
                        })
                        .colorMultiply(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
                    }
                    
                    Text("\(count)")
                        .font(.largeTitle)
                        .frame(width: 100, height: 40.0, alignment: .leading)
                        
                }else{
                    Text("\(count)")
                        .font(.largeTitle)
                        .frame(width: 100, height: 50.0)
                    if(count > 0){
                        Button(action: {
                            self.count = 0
                        }, label: {
                            Image(systemName: "trash")
                        })
                        .colorMultiply(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
                    }
                    
                }
            })
            
            Button(action: {
                print(wrist)
                self.count += 1
                print("timer is \(timerOn)")
            }, label: {
                Text("+")
                    .padding(.horizontal)
            })
            
            
            .padding(.vertical)
            .colorMultiply(.green)
            
            HStack(alignment: .center, spacing: 0, content: {
                
                if(wrist == 1){
                    NavigationLink(
                        destination: TimeView(timeRemaining: $timeRemaining, alarm: $timerOn, timeViewOn: $timeView), isActive: $timeView){
                        Text("Set")
                    }
                    .frame(width: 50)
                    Text("\(timeRemaining) s")
                        .font(.title2)
                        .frame(width: 100.0, height: 39.0, alignment: .trailing)
                }
                else{
                    Text("\(timeRemaining) s")
                        .font(.title2)
                        .frame(width: 100.0, height: 39.0, alignment: .leading)
                    NavigationLink(
                        destination: TimeView(timeRemaining: $timeRemaining, alarm: $timerOn, timeViewOn: $timeView), isActive: $timeView){
                        Text("Set")
                    }
                    .frame(width: 50)
                }
                
            })
            
                
                
        })
        .onReceive(timer) { time in
            
            var firstTime = true
            
            if timeRemaining > 0 {
                if(firstTime){
                    firstTime = false
                    startSession()
                    
                }
                timeRemaining -= 1
            }
            else if(timeRemaining == 0 && self.timerOn){
                print("alarm")
                WKInterfaceDevice.current().play(.notification)
                self.timerOn = false
                stopSession()
            }
        }
        .padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
