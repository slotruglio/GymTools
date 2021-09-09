//
//  ContentView.swift
//  Gym Tools WatchKit Extension
//
//  Created by Samuele Lo Truglio on 08/09/21.
//

import SwiftUI


//var wrist : Int = WKInterfaceDevice.current().wristLocation.rawValue
var wrist : Int = 0

var session: WKExtendedRuntimeSession!

class ExtensionDelegate: NSObject, WKExtensionDelegate, WKExtendedRuntimeSessionDelegate {

    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("Session stopped at", Date())
    }

    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Session started at", Date())
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {

    }

    func applicationDidBecomeActive() {

        session.delegate = self
    }
    
    func startSession() {
        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
    }
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
                if(wrist == 0){
                    Button(action: {
                        print(wrist)
                        self.count += 1
                        print("timer is \(timerOn)")
                    }, label: {
                        Text("+")
                            .padding(.horizontal)
                    })
                    .buttonStyle(GreenButton())
                    
                    Text("\(count)")
                        .font(.largeTitle)
                        .frame(width: 100, height: 40.0, alignment: .trailing)
                        
                }else{
                    Text("\(count)")
                        .font(.largeTitle)
                        .frame(width: 100, height: 50.0)
                    Button(action: {
                        self.count += 1
                    }, label: {
                        Text("+")
                    })
                    .padding(.leading, 5.0)
                }
            })
            
            
            Button(action: {
                self.count = 0
            }, label: {
                Text("Clear")
            })
            .padding(.vertical)
            .colorMultiply(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
            
            HStack(alignment: .center, spacing: 0, content: {
                NavigationLink(
                    destination: TimeView(timeRemaining: $timeRemaining, alarm: $timerOn, timeViewOn: $timeView), isActive: $timeView){
                    Text("Set")
                }
                .frame(width: 50.0)
                Text("\(timeRemaining) s")
                    .font(.title2)
                    .frame(width: 100.0, height: 39.0, alignment: .trailing)
            })
            
                
                
        })
        .onReceive(timer) { time in
            
            var firstTime = true
            
            if timeRemaining > 0 {
                if(firstTime){
                    firstTime = false
                    let test = ExtensionDelegate()
                    test.startSession()
                    
                }
                timeRemaining -= 1
            }
            else if(timeRemaining == 0 && self.timerOn){
                print("alarm")
                WKInterfaceDevice.current().play(.notification)
                self.timerOn = false
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
