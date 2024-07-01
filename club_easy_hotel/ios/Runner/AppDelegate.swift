import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Asegúrate de que el esquema de URL y el host coincidan con lo que has definido
    if url.scheme == "myapp" && url.host == "sessions" {
      // Aquí puedes extraer el parámetro 'token' del URL y realizar la acción deseada
      if let token = url.queryParameters["token"] {
        // Utiliza el token para validar la sesión con tu AuthService
        // Puedes necesitar comunicarte con tu controlador de Flutter para hacer esto
        // Por ejemplo, puedes enviar un mensaje al canal de Flutter para manejar el login
      }
    }
    return true
  }
}