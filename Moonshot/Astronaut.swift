//
//  Astronaut.swift
//  Moonshot
//
//  Created by Alex Oliveira on 10/05/2021.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    

    var missionsFlown: String {
        let allMissions: [Mission] = Bundle.main.decode("missions.json")
        
        var missions: [String] = []
        for mission in allMissions {
            for member in mission.crew {
                if member.name == self.id {
                    missions.append(mission.displayName)
                }
            }
        }
        
        return missions.joined(separator: ", ")
    }
}
