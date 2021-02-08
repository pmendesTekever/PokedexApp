import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonModel)
    func didFailWithError(error: Error)
}

struct PokemonManager {
    // Put this string somewhere else
    let pokemonURL = "https://pokeapi.co/api/v2/pokemon/"
    
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon(pokemonName: String) {
        let urlString = "\(pokemonURL)\(pokemonName)"
        performRequest(urlString: urlString)
    }
    
    func fetchPokemon(pokemonID: Int) {
        let urlString = "\(pokemonURL)\(pokemonID)"
        performRequest(urlString: urlString)
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
                    if let pokemon = self.parseJSON(safeData) {
                        delegate?.didUpdatePokemon(self, pokemon: pokemon)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ pokemonData: Data) -> PokemonModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
            let id = decodedData.id
            let name = decodedData.name
            let height = decodedData.height
            let weight = decodedData.weight
            
            let sprites = decodedData.sprites
            let otherSprites = sprites.other
            let artwork = otherSprites.artwork
            let frontDefault = artwork.frontDefault
            
            let availableMoves: Array = decodedData.moves
            var movesList = [String]()
            for moves in availableMoves {
                movesList.append(moves.move.name)
            }
            var randomMoves = [String]()
            while randomMoves.count < 3 {
                let randomMovePosition = Int.random(in: 0..<movesList.count)
                if !randomMoves.contains(movesList[randomMovePosition]) {
                    randomMoves.append(movesList[randomMovePosition])
                }
            }
            
            let stats = decodedData.stats
            var baseHP = 0
            var baseAttack = 0
            var baseDefense = 0
            var baseSpAttack = 0
            var baseSpDefense = 0
            var baseSpeed = 0
            for stat in stats {
                switch stat.stat.name {
                case "hp":
                    baseHP = stat.baseStat
                case "attack":
                    baseAttack = stat.baseStat
                case "defense":
                    baseDefense = stat.baseStat
                case "special-attack":
                    baseSpAttack = stat.baseStat
                case "special-defense":
                    baseSpDefense = stat.baseStat
                case "speed":
                    baseSpeed = stat.baseStat
                default:
                    print("Unknown Stat")
                }
            }

            let pokemonTypes = decodedData.types
            var types = [String]()
            for type in pokemonTypes {
                types.append(type.type.name)
            }
        
            let pokemon = PokemonModel(id: id, name: name, height: height, weight: weight, artwork: frontDefault, moves: randomMoves, baseHP: baseHP, baseAttack: baseAttack, baseDefense: baseDefense, baseSpAttack: baseSpAttack, baseSpDefense: baseSpDefense, baseSpeed: baseSpeed, types: types)

            return pokemon
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
