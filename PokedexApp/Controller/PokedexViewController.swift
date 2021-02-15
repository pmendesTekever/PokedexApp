import UIKit

class PokedexViewController: UIViewController {
    
    @IBOutlet weak var pokemonTableView: UITableView!
    
    var pokedexManager = PokedexManager()
    var pokemonManager = PokemonManager()
    var pokemonListArray: Array<PokemonModel> = []
    var sortedPokemonListArray: Array<PokemonModel> = []
    
    var pokemon: PokemonModel? = nil
    var artworkUrl: String?
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let typeTwoOpacity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokedexManager.delegate = self
        pokedexManager.fetchPokedex()
        
        pokemonManager.delegate = self
        
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetailsSegue" {
            pokemon = sortedPokemonListArray[pokemonTableView.indexPathForSelectedRow?.row ?? 0]
            if let destinationVC = segue.destination as? PokemonDetailsViewController {
                destinationVC.modalPresentationStyle = .fullScreen
                destinationVC.pokemon = pokemon
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension PokedexViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPokemonListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonCell
            if (indexPath.row <= sortedPokemonListArray.count - 1) {
                DispatchQueue.main.async {
                    guard
                        let pokemon = self.sortedPokemonListArray[indexPath.row] as? PokemonModel
                    else {
                        return
                    }
                    if pokemon.artwork != nil {
                        cell.pokemonCellImage.image = UIImage(data: (pokemon.artwork)!)
                    }
                    cell.pokemonCellName.text = pokemon.name
                    cell.pokemonCellNumber.text = "#\(pokemon.id)"
                    cell.pokemonCellTypeOne.setTitle(pokemon.types[0], for: .normal)
                    if pokemon.types.count > 1 {
                        cell.pokemonCellTypeTwo.setTitle(pokemon.types[1], for: .normal)
                        cell.pokemonCellTypeTwo.alpha = 1
                    } else {
                        cell.pokemonCellTypeTwo.alpha = CGFloat(self.typeTwoOpacity)
                    }
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == sortedPokemonListArray.count{
            pokedexManager.fetchPokedex()
        }
    }
}

//MARK: - UITableViewDelegate
extension PokedexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

//MARK: - PokedexManagerDelegate
extension PokedexViewController: PokedexManagerDelegate {
    func didUpdatePokedex(_ pokedexManager: PokedexManager, pokedex: PokedexModel) {
        pokemonManager.fetchPokemon(pokemonList: pokedex.results)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - PokemonManagerDelegate
extension PokedexViewController: PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonModel) {
        pokemonListArray.append(pokemon)
        sortedPokemonListArray = pokemonListArray.sorted(by: {$0.id < $1.id})
        
        DispatchQueue.main.async {
            self.pokemonTableView.reloadData()
        }
    }
}
