import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var pokemonTableView: UITableView!

    var pokedexManager = PokedexManager()
    var pokemonManager = PokemonManager()
    var pokemonListArray: Array<PokemonModel> = []
    var pokemon: PokemonModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        pokedexManager.delegate = self
        pokedexManager.fetchPokedex()
        
        pokemonManager.delegate = self
        
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.pokemonTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetailsSegue" {
            pokemon = pokemonListArray[pokemonTableView.indexPathForSelectedRow?.row ?? 0]
            if let destinationVC = segue.destination as? PokemonDetailsViewController {
                destinationVC.pokemon = pokemon
            }
//            let destinationVC = segue.destination as! PokemonDetailsViewController
//            destinationVC.pokemon = pokemon
        }
    }
}

//MARK: - UITableViewDataSource
extension PokedexViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Change this variable
        return pokedexManager.pokedexOffset
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonCell

        if (indexPath.row <= pokemonListArray.count - 1) {
            cell.pokemonCellName.text = self.pokemonListArray[indexPath.row].name
            cell.pokemonCellNumber.text = "No. \(self.pokemonListArray[indexPath.row].id)"
            cell.pokemonCellTypeOne.setTitle(self.pokemonListArray[indexPath.row].types[0], for: .normal)
            if self.pokemonListArray[indexPath.row].types.count == 2 {
                cell.pokemonCellTypeTwo.setTitle(self.pokemonListArray[indexPath.row].types[1], for: .normal)
            } else {
                cell.pokemonCellTypeTwo.alpha = 0
            }
        }

        return cell
    }
}

//MARK: - UITableViewDelegate
extension PokedexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
//        if let pokemonName = searchTextfield.text {
//            pokedexManager.fetchPokedex(pokedexName: pokedexName)
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

//MARK: - PokedexManagerDelegate
extension PokedexViewController: PokedexManagerDelegate {
    func didUpdatePokedex(_ pokedexManager: PokedexManager, pokedex: PokedexModel) {
        for listedPokemon in pokedex.results {
            pokemonManager.fetchPokemon(pokemonName: listedPokemon.name)
        }
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
    }
}
