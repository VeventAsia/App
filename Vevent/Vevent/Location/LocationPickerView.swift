import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var selectedLocation: String
    @Binding var isPresented: Bool
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629), // Center of India
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )
    @State private var locationName = ""
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none)
                    .onChange(of: region.center) { newCenter in
                        fetchLocationName(for: newCenter)
                    }
                    .edgesIgnoringSafeArea(.all)
                
                if !locationName.isEmpty {
                    Text("Selected Location: \(locationName)")
                        .padding()
                        .foregroundColor(.purple)
                }
                
                Button(action: {
                    selectedLocation = locationName
                    isPresented = false
                }) {
                    Text("Select this Location")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Select Location", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                isPresented = false
            })
            .onChange(of: searchText) { newValue in
                searchLocation(query: newValue)
            }
        }
    }
    
    private func searchLocation(query: String) {
        guard !query.isEmpty else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { placemarks, error in
            if let error = error {
                print("Error in geocoding: \(error)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                region.center = location.coordinate
                locationName = placemark.locality ?? "Unknown Location"
            } else {
                locationName = "No results found"
            }
        }
    }
    
    private func fetchLocationName(for location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                locationName = placemark.locality ?? "Unknown Location"
            } else {
                locationName = "Unknown Location"
            }
        }
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPickerView(selectedLocation: .constant("Goa"), isPresented: .constant(true))
    }
}
