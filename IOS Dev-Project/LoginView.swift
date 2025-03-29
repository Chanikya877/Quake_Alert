import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @Binding var isAuthenticated: Bool

    var body: some View {
        VStack {
            Text("Quake Alert App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 80)
            
            Spacer()
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Username", text: $username, isSecure: false)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
            }
            .padding(.horizontal, 30)
            
            Button(action: login) {
                Text("Login")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]),
                                   startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"),
                  message: Text("Incorrect username or password."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func login() {
        // Replace with your actual authentication logic
        if username == "admin" && password == "password" {
            isAuthenticated = true
            print("User authenticated")
        } else {
            showAlert = true
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.white.opacity(0.6))
                    .padding(.leading, 15)
            }
            if isSecure {
                SecureField("", text: $text)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            } else {
                TextField("", text: $text)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .autocapitalization(.none)
            }
        }
    }
}


