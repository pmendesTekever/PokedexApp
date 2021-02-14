import Foundation

struct PokemonData: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let moves: Array<PokemonMovesData>
    let stats: Array<Stats>
    let types: Array<Types>
}

struct PokemonMovesData: Codable {
    let move: PokemonMoveDetails
}

struct PokemonMoveDetails: Codable {
    let name: String
    let url: String
}

struct Stats: Codable {
    let baseStat: Int
    let stat: StatDetails
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat = "stat"
    }
}

struct Types: Codable {
    let type: TypeDetails
}

struct TypeDetails: Codable {
    let name: String
}

struct StatDetails: Codable {
    let name: String
}

struct Sprites: Codable {
    let other: OtherDictionary
}

struct OtherDictionary: Codable {
    let artwork: OtherArt

    enum CodingKeys: String, CodingKey {
        case artwork = "official-artwork"
    }
}

struct OtherArt: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case  frontDefault = "front_default"
    }
}
