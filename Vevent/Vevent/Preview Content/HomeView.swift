import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isCalendarPresented = false
    @State private var selectedDate = Date()
    @State private var showHostEventScreen = false
    @State private var isLocationPickerPresented = false
    @State private var selectedLocation = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text(locationManager.locationName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .lineLimit(1) // Ensure the text doesn't overflow
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            isLocationPickerPresented.toggle()
                        }) {
                            Image(systemName: "location.magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.purple)
                                .padding(10)
                                .background(Color("NeonPurple"))
                                .clipShape(Circle())
                                .frame(width: 44, height: 44)
                        }

                        Button(action: {
                            isCalendarPresented.toggle()
                        }) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.purple)
                                .padding(10)
                                .background(Color("NeonPurple"))
                                .cornerRadius(10)
                                .frame(width: 44, height: 44)
                        }
                    }
                }
                .padding()

                ScrollView {
                    VStack(spacing: 20) {
                        EventCard(eventName: "Ignite 2.0", location: "Slique Beach Club, Vagator", distance: "323 km", time: "8 PM", attendees: 61, checkInText: "1 Check-in", isLive: false, statusText: "Now", statusColor: "NeonPurple")
                        EventCard(eventName: "Candles On The Cliff", location: "Olive Bar & Kitchen, Goa", distance: "322 km", time: "8 PM", attendees: 37, checkInText: "Check-in", isLive: true, statusText: "Soon", statusColor: "NeonPurple")
                        EventCard(eventName: "Hangover Monday Night", location: "The Pink Elephant, Calangute", distance: "327 km", time: "6 PM", attendees: 42, checkInText: "", isLive: false, statusText: "Now", statusColor: "NeonPurple")
                    }
                    .padding()
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                HStack {
                    NavigationButton(imageName: "house", action: {
                        // Home action
                    })
                    Spacer()
                    NavigationButton(imageName: "magnifyingglass", action: {
                        // Search action
                    })
                    Spacer()
                    PlusButton(action: {
                        showHostEventScreen.toggle()
                    })
                    Spacer()
                    NavigationButton(imageName: "person", action: {
                        // Profile action
                    })
                    Spacer()
                    NavigationButton(imageName: "line.horizontal.3", action: {
                        // Menu action
                    })
                }
                .padding()
                .background(Color.black)
            }
        }
        .fullScreenCover(isPresented: $isCalendarPresented) {
            CalendarView(selectedDate: $selectedDate, isPresented: $isCalendarPresented)
        }
        .sheet(isPresented: $showHostEventScreen) {
            HostEventView()
        }
        .sheet(isPresented: $isLocationPickerPresented, onDismiss: {
            locationManager.updateLocation(from: selectedLocation) // Update location when picker is dismissed
        }) {
            LocationPickerView(selectedLocation: $selectedLocation, isPresented: $isLocationPickerPresented)
        }
    }
}

struct NavigationButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .foregroundColor(.gray)
                .font(.system(size: 24))
        }
    }
}

struct PlusButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(.purple)
                .font(.system(size: 24))
                .padding()
                .background(Color("NeonPurple"))
                .cornerRadius(30)
        }
    }
}

struct EventCard: View {
    let eventName: String
    let location: String
    let distance: String
    let time: String
    let attendees: Int
    let checkInText: String
    let isLive: Bool
    let statusText: String
    let statusColor: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(statusText)
                    .foregroundColor(.purple)
                    .padding(5)
                    .background(Color(statusColor))
                    .cornerRadius(5)
                Spacer()
            }
            Text(eventName)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            Text(location)
                .foregroundColor(.gray)
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.gray)
                Text(distance)
                    .foregroundColor(.gray)
                Spacer()
                Text(time)
                    .foregroundColor(.gray)
            }
            HStack {
                if !checkInText.isEmpty {
                    Button(action: {
                        // Check-in action
                    }) {
                        Text(checkInText)
                            .foregroundColor(.purple)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
                if isLive{
                    Button(action: {
                        // Live concert action
                    }) {
                        Text("Live Concert")
                            .foregroundColor(.purple)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(10)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isPresented.toggle()
                }) {
                    Text("Close")
                        .foregroundColor(.purple)
                        .padding()
                }
                Spacer()
            }
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .tint(.purple)
                
            Spacer()
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
