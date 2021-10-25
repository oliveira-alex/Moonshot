//
//  ContentView.swift
//  Moonshot
//
//  Created by Alex Oliveira on 10/05/2021.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var showingLaunchDate = true // toggles between showing the mission's launch date and showing it's crew names
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(decorative: mission.image)
                        .resizable()
                        .scaledToFit() //same as .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .accessibilityRemoveTraits(.isImage)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        if showingLaunchDate {
                            Text(mission.formattedLaunchDate)
                        } else {
                            Text(mission.crewNames)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(mission.displayName)
                    .accessibilityValue(showingLaunchDate ?
                                        "\(mission.formattedLaunchDate == "N/A" ? "Launch date: not available" : mission.formattedLaunchDate)" :
                                        mission.crewNames
                    )
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing:
                                    Button(showingLaunchDate ? "Crew Names" : "Launch Date") {
                                        self.showingLaunchDate.toggle()
                                    }
                                    .accessibilityLabel("\(showingLaunchDate ? "Show crewmember names" : "Show launch date")")
            )
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
