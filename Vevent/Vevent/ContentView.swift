import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var loginError: String?
    @State private var isLoading = false  // New state for loading

    var body: some View {
        ZStack {
            if isAuthenticated {
                HomeView()
            } else {
                VStack {
                    Text("Vevent")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("NeonBlue"), Color("NeonPurple")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .padding(.bottom, 50)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .foregroundColor(.purple)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .foregroundColor(.purple)

                    if let loginError = loginError {
                        Text(loginError)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                    }

                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .foregroundColor(.purple)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("NeonPurple"))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)

                    Button(action: {
                        // Replace with your signup logic
                        register()
                    }) {
                        Text("Signup If You Don't Have an Account")
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("NeonBlue"))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .blur(radius: isLoading ? 3 : 0)  // Blur the content when loading
            }

            if isLoading {
                VStack {
                    Spacer()
                    ProgressView("Logging in...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .padding()
                    Spacer()
                }
                .background(Color.black.opacity(0.8))  // Slightly opaque background
                .cornerRadius(10)
                .frame(width: 150, height: 150)
            }
        }
    }

    private func login() {
        isLoading = true  // Start loader
        ApiClient.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Login successful: \(response)")
                    isAuthenticated = true
                case .failure(let error):
                    loginError = "Login failed: \(error.localizedDescription)"
                }
                isLoading = false  // Stop loader
            }
        }
    }
    
    private func register() {
        // Implement registration logic if needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
