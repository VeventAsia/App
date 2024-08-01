import SwiftUI

struct HostEventView: View {
    @State private var eventName = ""
    @State private var eventLocation = ""
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    @State private var numberOfAttendees = ""
    
    @State private var isLocationPickerPresented = false
    @State private var selectedLocation = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $eventName)
                    Button(action: {
                        isLocationPickerPresented.toggle()
                    }) {
                        HStack {
                            Text("Location")
                                .fontWeight(.bold)
                            Spacer()
                            Text(selectedLocation.isEmpty ? "Select Location" : selectedLocation)
                                .foregroundColor(selectedLocation.isEmpty ? .gray : .purple)
                                .italic()
                        }
                    }
                    .tint(.purple) // Apply tint to the button
                    .sheet(isPresented: $isLocationPickerPresented) {
                        LocationPickerView(selectedLocation: $selectedLocation, isPresented: $isLocationPickerPresented)
                            .onDisappear {
                                eventLocation = selectedLocation
                            }
                    }
                    DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                        .tint(.purple)
                    DatePicker("Event Time", selection: $eventTime, displayedComponents: .hourAndMinute)
                    TextField("Number of Attendees", text: $numberOfAttendees)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        // Handle event submission here
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Host Event", displayMode: .inline)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct HostEventView_Previews: PreviewProvider {
    static var previews: some View {
        HostEventView()
    }
}
