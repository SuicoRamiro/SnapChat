import UIKit
import Firebase
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura Google Sign-In con el clientID desde Firebase
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        // Iniciamos el proceso de Google Sign-In
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                return
            }

            // Verificamos que tengamos las credenciales correctas de Google
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {  // Eliminamos la cadena opcional
                print("Error: No se pudo obtener el ID Token o Access Token.")
                return
            }
            let accessToken = user.accessToken.tokenString

            // Crea credenciales para Firebase con los tokens de Google
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            // Autentica al usuario en Firebase con las credenciales de Google
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error al autenticar en Firebase: \(error.localizedDescription)")
                } else {
                    print("Inicio de sesión exitoso con Google y Firebase!")
                    // Aquí podrías redirigir al usuario a la siguiente vista, si lo deseas
                }
            }
        }
    }
}
