import UIKit

class PokedexViewController: UIViewController {
    
    @IBOutlet weak var pokemonTableView: UITableView!
    
    var pokedexManager = PokedexManager()
    var pokemonManager = PokemonManager()
    var pokemonListArray: Array<PokemonModel> = []
    
    var pokemon: PokemonModel? = nil
    var artworkUrl: String?
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)

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
            pokemon = pokemonListArray[pokemonTableView.indexPathForSelectedRow?.row ?? 0]
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
        return pokemonListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonCell
            if (indexPath.row <= pokemonListArray.count - 1) {
                DispatchQueue.main.async {
                    let imageData = try? Data(contentsOf: URL(string: self.pokemonListArray[indexPath.row].artwork)!)
                    cell.pokemonCellImage.image = UIImage(data: imageData!)
                    cell.pokemonCellName.text = self.pokemonListArray[indexPath.row].name
                    cell.pokemonCellNumber.text = "#\(self.pokemonListArray[indexPath.row].id)"
                    cell.pokemonCellTypeOne.setTitle(self.pokemonListArray[indexPath.row].types[0], for: .normal)
                    if self.pokemonListArray[indexPath.row].types.count > 1 {
                        cell.pokemonCellTypeTwo.setTitle(self.pokemonListArray[indexPath.row].types[1], for: .normal)
                    } else {
                        cell.pokemonCellTypeTwo.alpha = 0
                    }
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == pokemonListArray.count && pokemonListArray.count >= pokedexManager.pokedexOffset - 1 {
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
        //pokedexListArray.append(pokedex)
        pokemonManager.fetchPokemon(pokemonList: pokedex.results)
//        DispatchQueue.main.async {
//            self.view.addSubview(self.activityIndicatorView)
//            self.activityIndicatorView.startAnimating()
//        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - PokemonManagerDelegate
extension PokedexViewController: PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonModel) {
        //check for crashes here
        pokemonListArray.append(pokemon)
        
        DispatchQueue.main.async {
            self.pokemonTableView.reloadData()
        }
        print("POKEMON #\(pokemon.id)")
//        if (pokemonListArray.count == pokedexManager.pokedexOffset) {
//            DispatchQueue.main.async {
//                self.pokemonTableView.reloadData()
//                self.activityIndicatorView.stopAnimating()
//            }
//        }
    }
}

//MARK: - UITextFieldDelegate
//extension PokedexViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextfield.endEditing(true)
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        var searchedPokemon: PokemonModel
//        if let pokemonName = searchTextfield.text {
//            searchedPokemon = pokemonManager.fetchPokedex(pokemonName: pokemonName)
//        }
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            textField.placeholder = "Search"
//            return true
//        } else {
//            textField.placeholder = "Choose a Pokémon"
//            return false
//        }
//    }
//}
