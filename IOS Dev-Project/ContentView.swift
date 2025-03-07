import SwiftUI
import MapKit

struct SeismicApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}


struct MainView: View {
    var body: some View {

        if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
    
            NavigationSplitView {
                SidebarView()
            } detail: {
                DashboardView()
            }
        } else {
           
            NavigationView {
                SidebarView()
                DashboardView()
            }
        }
    }
}
struct SidebarView: View {
    var body: some View {
        List {
            NavigationLink(destination: DashboardView()) {
                Label("Dashboard", systemImage: "house.fill")
            }
            NavigationLink(destination: DocsView()) {
                Label("Docs", systemImage: "folder.fill")
            }
            NavigationLink(destination: PrecautionsView()) {
                Label("Precautions", systemImage: "exclamationmark.triangle.fill")
            }
            NavigationLink(destination: LiveMapView()) {
                Label("Live Map", systemImage: "map.fill")
            }
            NavigationLink(destination: EmergencyContactsView()) {
                Label("Emergency Contacts", systemImage: "phone.fill")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Menu")
    }
}

struct DashboardView: View {
    @State private var randomNumber: String = ""
    @State private var message: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {

                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Dashboard")
                            .font(.custom("Avenir Next", size: 36))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Image("user")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                    .padding()

                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                            NavigationLink(destination: DocsView()) {
                                DashboardCard(imageName: "folder", title: "DOCS", subtitle: "Seismic")
                            }
                            NavigationLink(destination: PrecautionsView()) {
                                DashboardCard(imageName: "precaution", title: "PreCautions", subtitle: "Seismic")
                            }
                            NavigationLink(destination: LiveMapView()) {
                                DashboardCard(imageName: "Map", title: "LiveMap", subtitle: "Seismic")
                            }
                            NavigationLink(destination: EmergencyContactsView()) {
                                DashboardCard(imageName: "emergency", title: "EmergencyContacts", subtitle: "Seismic")
                            }
                        }
                        .padding()

                        
                        Card {
                            VStack {
                                Text("Random Value from Server: \(randomNumber)")
                                    .font(.custom("Avenir Next", size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 340, height: 160)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                fetchRandomNumber()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(message), dismissButton: .default(Text("OK")))
            }
        }
    }
    func fetchRandomNumber() {
        guard let url = URL(string: "http://localhost:9080") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.randomNumber = responseString
                    self.setMessage(number: Int(responseString) ?? 0)
                    self.showAlert = true
                }
            }
        }.resume()
    }
    func setMessage(number: Int) {
        if number < 5 {
            self.message = "felt by all; minor breakage of objects"
        } else if number >= 5 && number < 7 {
            self.message = "moderate damage in populated areas"
        } else if number >= 7 && number < 9 {
            self.message = "severe destruction and loss of life over large areas-----> Go for Emergency Contacts"
        } else {
            self.message = "Unknown"
        }
    }
}

struct Card<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

struct DashboardCard: View {
    var imageName: String
    var title: String
    var subtitle: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 64, height: 64)
                .padding(.top, 10)
            Text(title)
                .font(.custom("Avenir Next", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 5)
            Text(subtitle)
                .font(.custom("Avenir Next", size: 14))
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 10)
        }
        .frame(width: 160, height: 160)
        .background(Color(red: 0.1, green: 0.1, blue: 0.2))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
    }
}

struct DocsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("EPICENTER (Earthquake Prediction)")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image("epi")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)

                Text("GEOLOGICAL MAP OF GANGTOK AREA")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image("geo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)

                Text("Seismograph")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image("seismograph")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)

                Text("Sevearity Scale")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image("sevearity")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)

                Text("Location of Seismograph Station")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image("location")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)]), startPoint: .top, endPoint: .bottom))
        .navigationTitle("Docs")
    }
}
struct PrecautionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Drop. Cover. Hold on.")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("""
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum
                """)
                    .font(.custom("Avenir Next", size: 16))
                    .foregroundColor(.white.opacity(0.8))

                Text("If you are in a high-rise building.")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("""
                Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

                The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
                """)
                    .font(.custom("Avenir Next", size: 16))
                    .foregroundColor(.white.opacity(0.8))

                Text("If you are inside a crowded place.")
                    .font(.custom("Avenir Next", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("""
                It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                """)
                    .font(.custom("Avenir Next", size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)]), startPoint: .top, endPoint: .bottom))
        .navigationTitle("Precautions")
    }
}

// MARK: - Live Map View
struct LiveMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 27.338936, longitude: 88.606506),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [
            AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 27.338936, longitude: 88.606506)),
            AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 27.340500, longitude: 88.610500))
        ]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .navigationTitle("Live Map")
    }
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
struct EmergencyContactsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Police Helpline Numbers:")
                .font(.custom("Avenir Next", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("03592-202892 - Landline")
                .font(.custom("Avenir Next", size: 16))
                .foregroundColor(.white.opacity(0.8))
            Text("03592-221152 - Landline")
                .font(.custom("Avenir Next", size: 16))
                .foregroundColor(.white.opacity(0.8))
            Text("8001763383 - Mobile")
                .font(.custom("Avenir Next", size: 16))
                .foregroundColor(.white.opacity(0.8))
            Text("03592-202042 - Fax")
                .font(.custom("Avenir Next", size: 16))
                .foregroundColor(.white.opacity(0.8))
            Text("Or call '112' for emergency assistance.")
                .font(.custom("Avenir Next", size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)]), startPoint: .top, endPoint: .bottom))
        .navigationTitle("Emergency Contacts")
    }
}
