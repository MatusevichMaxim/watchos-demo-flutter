//
//  ContentView.swift
//  watchOSProj Watch App
//
//  Created by Maksim Matusevich on 5/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sessionManager = WatchSessionManager()
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                sessionManager.increment()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
            }
            
            Text("\(sessionManager.counter)")
                .font(.system(size: 40))
                .monospacedDigit()
            
            Button(action: {
                sessionManager.decrement()
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 40))
            }
        }
        .onAppear {
            sessionManager.activate()
        }
    }
}

#Preview {
    ContentView()
}
