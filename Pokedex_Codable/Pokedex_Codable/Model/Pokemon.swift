//
//  Pokemon.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation
// TOP LEVEL DICTIONARY
// End point 1
struct Pokedex: Decodable {
    private enum CodingKeys: String, CodingKey {
        case next = "next"
        case results
    }
    let next: String
    let results: [ResultsDictionary]
}

struct ResultsDictionary: Decodable {
    let name: String
    let url: String
}
// EndPoint 2
struct Pokemon: Decodable {
    enum Keys: String {
        case name = "name"
        case id = "id"
        case sprites = "sprites"
        case moves = "moves"
    }
    let name: String
    let id: Int
    let sprites: Sprites
    let moves: [Moves]
}

struct Sprites: Decodable {
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontShinyFemale = "front_shiny_female"
    }
    let frontDefault: String
    let frontShiny: String
    let frontFemale: String?
    let frontShinyFemale: String?
}

struct Moves: Decodable {
    private enum CodingKeys: String, CodingKey {
        case move = "move"
    }
    let move: Move
}
struct Move: Decodable {
    private enum CodingKeys: String, CodingKey {
        case moveName = "name"
       
    }
    let moveName: String
    
}
