import Flutter
import UIKit
import MusicKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    private var musicKitBridge: AnyObject?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        if #available(iOS 15, *),
           let messenger = engineBridge.pluginRegistry.registrar(forPlugin: "MusicKitBridge")?.messenger() {
            let bridge = MusicKitBridge()
            bridge.setup(binaryMessenger: messenger)
            musicKitBridge = bridge
        }
    }
}
