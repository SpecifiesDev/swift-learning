//
//  ContentView.swift
//  austin-watch Watch App
//
//  Created by austin gable on 1/1/25.
//

import SwiftUI

struct ContentView: View {
    
    // simulate a loading bar
    @State private var progressWidth: CGFloat = 0
    
    // determine if the loading has been completed
    @State private var isLoadingComplete: Bool = false
    
    // set the default bar and gradient color
    @State private var gradientTop: Color = .mint
    
    // set the end color / gradient
    @State private var gradientBottom: Color = .blue
    
    // state of the loading bar color to animate
    @State private var loadingBarColor: Color = .blue
    
    // default width for the loading bar
    let loadingBarWidth: CGFloat = 150
    
    // fancy loading animation string
    @State private var characters = Array("Loading Austin's App")
    @State private var fallen: Bool = false
    @State private var offsets: [CGFloat] = []
    
    // value for loading time
    @State private var loadingTime: Double = 7.0
    
    
    var body: some View {
        // use a zstack to load elements in order
        ZStack {
            LinearGradient(gradient: Gradient(colors: [gradientTop, gradientBottom]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if isLoadingComplete {
                // show welcome once loaded
                Text("Welcome!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .transition(.scale) // scale animation
            } else {
                
                // loading screen
                VStack(spacing: 20) {
                    
                    // animate the text
                    HStack(spacing: 0) {
                        ForEach(0..<characters.count, id: \.self) { i in
                            Text(String(characters[i]))
                                .foregroundColor(.white)
                                .offset(y: offsets.indices.contains(i) ? offsets[i] : 0)
                                .animation(.easeInOut(duration: 1), value: fallen)
                        }
                    }
                    
                    ZStack(alignment: .leading) {
                        
                        // construct the progress bar
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: loadingBarWidth, height: 20)
                        
                        // create a foreground actual loading animation
                        RoundedRectangle(cornerRadius: 10)
                            .fill(loadingBarColor)
                            .frame(width: progressWidth, height: 20)
                            .animation(.linear(duration: loadingTime), value: progressWidth)
                    }
                }
                
            }
        }
        .onAppear {
            progressWidth = loadingBarWidth
            
            // adjust the color of the loading bar
            withAnimation(.linear(duration: loadingTime)) {
                loadingBarColor = gradientTop
            }
            
            // after 5 seconds switch to the welcome screen
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingTime) {
                
                withAnimation(.easeInOut) {
                    isLoadingComplete = true
                    
                }
            }
            
            // init offset array, one entry per char
            offsets = Array(repeating: 0, count: characters.count)
            
            
            // after .5 seconds have characters fall
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                fallCharacters()
            }
            
            // after 2.5 seconds have characters rise
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                riseCharacters()
            }
            
    
            
            
        }
    }
    
    // utility methods for animating falling characters
    private func fallCharacters() {
        for i in 0..<characters.count {
            
            // small delay for each fall
            let delay = Double(i) * 0.09
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 1)) {
                    offsets[i] = 300
                }
            }
        }
    }
    
    private func riseCharacters() {
        for i in 0..<characters.count {
            let delay = Double(i) * 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 1)) {
                    offsets[i] = 0
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
