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
            var pokemonImage: Data? = nil
            if let image = try? Data(contentsOf: URL(string: frontDefault)!) {
                pokemonImage = image
            }
            
            let availableMoves: Array = decodedData.moves
            var movesList = [String]()
            movesList.append(contentsOf: availableMoves.map( {$0.move.name}))
            
            var randomMoves = [String]()
            if movesList.count > 0 {
                while randomMoves.count < Constants.randomMovesCount {
                    let randomMovePosition = Int.random(in: 0..<movesList.count)
                    if !randomMoves.contains(movesList[randomMovePosition]) {
                        randomMoves.append(movesList[randomMovePosition])
                    }
                }
            } else {
                randomMoves.append("Struggle")
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
                    totalCP += baseHP
                case statsStrings.attack.rawValue:
                    baseAttack = stat.baseStat
                    totalCP += baseAttack
                case statsStrings.defense.rawValue:
                    baseDefense = stat.baseStat
                    totalCP += baseDefense
                case statsStrings.specialAttack.rawValue:
                    baseSpAttack = stat.baseStat
                    totalCP += baseSpAttack
                case statsStrings.specialDefense.rawValue:
                    baseSpDefense = stat.baseStat
                    totalCP += baseSpDefense
                case statsStrings.speed.rawValue:
                    baseSpeed = stat.baseStat
                    totalCP += baseSpeed
                default:
                    print("Unknown Stat")
                }
            }
            
            let pokemonTypes = decodedData.types
            var types = [String]()
            for type in pokemonTypes {
                types.append(type.type.name)
            }
            
            let pokemon = PokemonModel(id: id, name: name, height: height, weight: weight, artwork: pokemonImage, moves: randomMoves, baseHP: baseHP, baseAttack: baseAttack, baseDefense: baseDefense, baseSpAttack: baseSpAttack, baseSpDefense: baseSpDefense, baseSpeed: baseSpeed, totalCP: totalCP, types: types)
            
            return pokemon
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
