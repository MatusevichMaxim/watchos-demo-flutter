import Flutter
import UIKit
import WatchConnectivity

@main
@objc class AppDelegate: FlutterAppDelegate {
    var channel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        initFlutterChannel()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initFlutterChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }
        
        channel = FlutterMethodChannel(name: "com.maksim.demoWatchOS", binaryMessenger: controller.binaryMessenger)
        channel?.setMethodCallHandler { [weak self] (call, result) in
            guard let self else { return }
            
            if call.method == "updateCounter", let args = call.arguments as? [String: Any], let value = args["value"] as? Int {
                self.sendToWatch(value: value)
                result(nil)
            }
        }
    }
    
    private func sendToWatch(value: Int) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["value": value], replyHandler: nil, errorHandler: nil)
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["value"] as? Int {
            channel?.invokeMethod("watchUpdated", arguments: ["value": value])
        }
    }
}
