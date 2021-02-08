import Foundation

protocol PokedexManagerDelegate {
    func didUpdatePokedex(_ pokedexManager: PokedexManager, pokedex: PokedexModel)
    func didFailWithError(error: Error)
}

struct PokedexManager {
    // Put this string somewhere else
    let pokedexURL = "https://pokeapi.co/api/v2/pokemon/?limit=20&offset="
    var pokedexOffset = 0
    
    var delegate: PokedexManagerDelegate?
    
    mutating func fetchPokedex() {
        let urlString = "\(pokedexURL)\(pokedexOffset)"
        performRequest(urlString: urlString)
        self.pokedexOffset += 20
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let pokedex = self.parseJSON(safeData) {
                        delegate?.didUpdatePokedex(self, pokedex: pokedex)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ pokedexData: Data) -> PokedexModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PokedexData.self, from: pokedexData)
            let next = decodedData.next
            let previous = decodedData.previous
            
            let results: Array = decodedData.results
            
            let pokedex = PokedexModel(next: next, previous: previous, results: results)

            return pokedex
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
