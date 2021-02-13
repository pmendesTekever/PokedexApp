import Foundation

struct Constants {
    static let pokedexURL = "https://pokeapi.co/api/v2/pokemon/?limit=20&offset="
    static let pokemonURL = "https://pokeapi.co/api/v2/pokemon/"
    static let pokedexOffset = 20
    static let randomMovesCount = 3
}

enum statsStrings: String {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"
}
