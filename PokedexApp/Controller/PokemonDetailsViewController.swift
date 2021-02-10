import UIKit

class PokemonDetailsViewController: UIViewController {
    
    var pokemon: PokemonModel? = nil
    
    @IBOutlet weak var pokemonName: UILabel!
    
    override func viewDidLoad() {
        pokemonName.text = pokemon?.name ?? "Pokémon"
    }

}
