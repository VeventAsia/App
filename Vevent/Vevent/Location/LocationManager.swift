import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    @Published var locationName: String = "Fetching Location..."
    
    private let locationManager = CLLocationManager()
    private var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchCurrentLocation() {
        // Ensure location services are enabled and authorization is granted
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager().authorizationStatus
            if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
                locationManager.requestLocation()
            } else {
                locationName = "Location services not authorized"
            }
        } else {
            locationName = "Location services are not enabled"
        }
    }
    
    func updateLocation(from address: String) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error in geocoding address: \(error)")
                    self?.locationName = "Failed to get location name"
                    return
                }
                if let placemark = placemarks?.first {
                    self?.locationName = placemark.locality ?? "Unknown Location"
                } else {
                    self?.locationName = "Unknown Location"
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error in reverse geocoding: \(error)")
                        self?.locationName = "Failed to get location name"
                        return
                    }
                    if let placemark = placemarks?.first {
                        self?.locationName = placemark.locality ?? "Unknown Location"
                    } else {
                        self?.locationName = "Unknown Location"
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationName = "Failed to get location"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle authorization status changes
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            fetchCurrentLocation()
        case .denied, .restricted:
            locationName = "Location services not authorized"
        case .notDetermined:
            // Waiting for user to grant permission
            break
        @unknown default:
            locationName = "Unknown authorization status"
        }
    }
}
