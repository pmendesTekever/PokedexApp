import Foundation

struct PokedexData: Codable {
    let next: String
    let previous: String?
    let results: Array<ResultsData>
}

struct ResultsData: Codable {
    let name: String
    let url: String
}
