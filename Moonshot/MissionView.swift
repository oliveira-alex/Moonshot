//
//  MissionView.swift
//  Moonshot
//
//  Created by Alex Oliveira on 11/05/2021.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            let badgeOriginalMaxHeight = geometry.size.width * 0.7
            
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { badgeGeometry in
                        let badgeNewMaxHeight = badgeGeometry.frame(in: .global).maxY - geometry.frame(in: .global).minY
                        let badgeNewScale = badgeNewMaxHeight / badgeOriginalMaxHeight
                        
                        Image(self.mission.image)
                            .resizable()
                            .scaleEffect(badgeNewScale >= 0.8 ? badgeNewScale : 0.8, anchor: .bottom)
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width)
                            .padding()
                            .accessibilityRemoveTraits(.isImage)
                    }
                    .frame(height: badgeOriginalMaxHeight)
                    
                    Text("Launch Date: \(self.mission.formattedLaunchDate)")
                        .font(.headline)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel(mission.formattedLaunchDate == "N/A" ? "Launch date: not available" : "Launch date: \(mission.formattedLaunchDate)")
                    
                    Text(self.mission.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(decorative: crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                    .accessibilityRemoveTraits(.isImage)
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[1], astronauts: astronauts)
    }
}
