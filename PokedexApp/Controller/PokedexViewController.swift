import UIKit

class PokedexViewController: UIViewController {

    var pokedexManager = PokedexManager()

    @IBAction func btnPressed(_ sender: Any) {
        let pokemonManager = PokemonManager()
        pokemonManager.fetchPokemon(pokemonName: "dragonite")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokedexManager.delegate = self
        pokedexManager.fetchPokedex()
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

//MARK: - PokemonManagerDelegate
extension PokedexViewController: PokedexManagerDelegate {
    func didUpdatePokedex(_ pokedexManager: PokedexManager, pokedex: PokedexModel) {
        DispatchQueue.main.async {
            //self.pokedexNumber.text = String(format: "\(pokedex)")
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
