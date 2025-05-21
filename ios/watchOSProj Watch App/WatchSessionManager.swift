//
//  WatchSessionManager.swift
//  Runner
//
//  Created by Maksim Matusevich on 5/21/25.
//

import Foundation
import WatchConnectivity
import Combine

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    private var session: WCSession { WCSession.default }
    
    @Published var counter: Int = 0
    
    func activate() {
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func increment() {
        counter += 1
        sendToPhone()
    }
    
    func decrement() {
        counter -= 1
        sendToPhone()
    }
    
    private func sendToPhone() {
        if session.isReachable {
            session.sendMessage(["value": counter], replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["value"] as? Int {
            DispatchQueue.main.async {
                self.counter = value
            }
        }
    }
}
