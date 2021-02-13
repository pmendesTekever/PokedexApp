import UIKit

class PokemonDetailsViewController: UIViewController {
    
    var pokemon: PokemonModel? = nil
    
    @IBOutlet weak var CPLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonFirstType: UIButton!
    @IBOutlet weak var pokemonSecondType: UIButton!
    @IBOutlet weak var pokemonFirstAttack: UILabel!
    @IBOutlet weak var pokemonSecondAttack: UILabel!
    @IBOutlet weak var pokemonThirdAttack: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var spAtkLabel: UILabel!
    @IBOutlet weak var spDefLabel: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    
    var totalCP = 0

    override func viewDidLoad() {
        // NO !!!
        if pokemon != nil {
            totalCP = pokemon!.baseHP + pokemon!.baseAttack + pokemon!.baseDefense + pokemon!.baseSpAttack + pokemon!.baseSpDefense + pokemon!.baseSpeed
        }
        CPLabel.text = "\(totalCP)"
        let imageData = try? Data(contentsOf: URL(string: pokemon?.artwork ?? "")!)
        pokemonImage.image = UIImage(data: imageData!)
        pokemonName.text = pokemon?.name ?? "Pokémon"
        pokemonWeight.text = "\(pokemon?.weight ?? 0)Kg"
        pokemonHeight.text = "\(pokemon?.height ?? 0)m"

        pokemonFirstType.setTitle("\(String(describing: pokemon?.types[0]))", for: .normal)
        if (pokemon?.types.count == 2) {
            pokemonSecondType.setTitle("\(pokemon?.types[1])", for: .normal)
        } else {
            pokemonSecondType.isHidden = true
        }
        // Not all Pokemons can have 3 attacks - needs to be optional
        pokemonFirstAttack.text = pokemon?.moves[0]
        pokemonSecondAttack.text = pokemon?.moves[1]
        pokemonThirdAttack.text = pokemon?.moves[2]
        hpLabel.text = "\(pokemon?.baseHP)"
        attackLabel.text = "\(pokemon?.baseAttack)"
        defenseLabel.text = "\(pokemon?.baseDefense)"
        spAtkLabel.text = "\(pokemon?.baseSpAttack)"
        spDefLabel.text = "\(pokemon?.baseSpDefense)"
        speedLbl.text = "\(pokemon?.baseSpeed)"
    
    }

}
