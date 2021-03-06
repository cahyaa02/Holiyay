//
//  DestinationDetail.swift
//  Holiyay
//
//  Created by MacBook Pro on 11/05/22.
//

import Foundation
import SwiftUI

struct DestinationDetail: View {
    @State private var isPresented = false
    @EnvironmentObject var destinationData: DestinationData
    var destination: Destination
    
    var destinationIndex: Int {
        destinationData.destinations.firstIndex(where: { $0.id == destination.id }) ?? 0
    }
    
    var body: some View {
        ScrollView {
            MapView(coordinate: destination.locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 256)
//                .overlay(
//                    Button {
//                    } label: {
//                        Label("Open in Maps", systemImage: "location.fill")
//                    }
//                        .buttonStyle(SecondaryButton())
//                )
            
            VStack(alignment: .leading) {
                HStack {
                    Text(destination.name)
                        .font(.title)
                        .fontWeight(.heavy)
                }
                
                HStack(spacing: 18) {
                    Text(destination.category.rawValue)
                        .padding(14)
                        .background(Capsule().stroke(lineWidth: 2))
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Label(destination.city + ", " + destination.country, systemImage: "pin.fill")
                        .font(.system(size: 18, weight: .medium, design: .default))
                }
                .font(.subheadline)
                .foregroundColor(Color("Muted"))
                
                Divider()
                    .padding(.vertical, 7.5)
                
                Text(destination.description)
                    .padding(.bottom)
               
                Button {
                    isPresented.toggle()
                } label: {
                    Label(destination.visitDate ?? "Plan The Visit Date", systemImage: "calendar")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButton())
                .fullScreenCover(isPresented: $isPresented) {
                    FullScreenModalView(destination: self.destination)
                }
            }
            .padding()
        }
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var destinationData: DestinationData
    var destination: Destination
    
    var destinationIndex: Int {
        destinationData.destinations.firstIndex(where: { $0.id == destination.id })!
    }
    @State var visitDate = Date()

    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: visitDate)
    }
    
    var body: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .padding()
        
        VStack {
            Text("Set Plan")
                .font(.title2)
                .fontWeight(.heavy)
                .padding()
            
            Image("visit_date")
                .resizable()
                .scaledToFit()
                .padding(.bottom)
            
            DatePicker(selection: $visitDate, in: Date.now..., displayedComponents: .date) {
            }
            .onChange(of: visitDate) { _ in
                MyBookmark.setup()
                MyBookmark.destinations[destinationIndex].isBookmark = true
                MyBookmark.destinations[destinationIndex].visitDate = dateFormat()
                print(dateFormat())
            }
            .datePickerStyle(GraphicalDatePickerStyle())
            .accentColor(Color("Primary"))
            .clipped()
            .labelsHidden()
            .padding(.horizontal)
            
            Text("Set Visit Date on: \(visitDate.formatted(date: .long, time: .omitted))")
                .foregroundColor(Color("Muted"))
                .padding()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Save to Bookmark", systemImage: "bookmark.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButton())
            .padding(.top, 24)
            .padding(.horizontal)
        }
    }
}

struct DestinationDetail_Previews: PreviewProvider {
    static let destinationData = DestinationData()
    
    static var previews: some View {
        DestinationDetail(destination: DestinationData().destinations[0])
            .environmentObject(destinationData)
    }
}
