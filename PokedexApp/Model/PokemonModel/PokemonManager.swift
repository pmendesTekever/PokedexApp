import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonModel)
    func didFailWithError(error: Error)
}

struct PokemonManager {
    let pokemonURL = Constants.pokemonURL
    var delegate: PokemonManagerDelegate?

    func fetchPokemon(pokemonList: Array<ResultsData>) {
        for pokemons in pokemonList {
            performRequest(urlString: pokemons.url)
            sleep(UInt32(1.2))
        }
    }
    
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
            while randomMoves.count < Constants.randomMovesCount {
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
            var totalCP = 0
            
            for stat in stats {
                switch stat.stat.name {
                case statsStrings.hp.rawValue:
                    baseHP = stat.baseStat
                case statsStrings.attack.rawValue:
                    baseAttack = stat.baseStat
                case statsStrings.defense.rawValue:
                    baseDefense = stat.baseStat
                case statsStrings.specialAttack.rawValue:
                    baseSpAttack = stat.baseStat
                case statsStrings.specialDefense.rawValue:
                    baseSpDefense = stat.baseStat
                case statsStrings.speed.rawValue:
                    baseSpeed = stat.baseStat
                default:
                    print("Unknown Stat")
                }
            }
            
            totalCP = baseHP + baseAttack + baseDefense + baseSpAttack + baseSpDefense + baseSpeed
            
            let pokemonTypes = decodedData.types
            var types = [String]()
            for type in pokemonTypes {
                types.append(type.type.name)
            }
        
            let pokemon = PokemonModel(id: id, name: name, height: height, weight: weight, artwork: frontDefault, moves: randomMoves, baseHP: baseHP, baseAttack: baseAttack, baseDefense: baseDefense, baseSpAttack: baseSpAttack, baseSpDefense: baseSpDefense, baseSpeed: baseSpeed, totalCP: totalCP, types: types)

            return pokemon
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
