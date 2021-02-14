import Foundation

struct PokemonModel {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let artwork: String
    let moves: [String]
    let baseHP: Int
    let baseAttack: Int
    let baseDefense: Int
    let baseSpAttack: Int
    let baseSpDefense: Int
    let baseSpeed: Int
    let totalCP: Int
    let types: Array<String>
}
