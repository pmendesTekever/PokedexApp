import UIKit

class PokemonDetailsViewController: UIViewController {
    
    var pokemon: PokemonModel? = nil
    
    @IBOutlet weak var CPLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonDetailsScrollView: UIScrollView!
    @IBOutlet weak var detailsView: UIView!
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
    
    @IBAction func bancBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var totalCP = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // NO !!!
        // CALCULATE CP ON POKEMONMANAGER
        detailsView.layer.cornerRadius = 10
        self.modalPresentationStyle = .fullScreen

        if pokemon != nil {
            totalCP = pokemon!.baseHP + pokemon!.baseAttack + pokemon!.baseDefense + pokemon!.baseSpAttack + pokemon!.baseSpDefense + pokemon!.baseSpeed
        }
        CPLabel.text = "CP \(totalCP)"
        let imageData = try? Data(contentsOf: URL(string: pokemon?.artwork ?? "")!)
        pokemonImage.image = UIImage(data: imageData!)
        pokemonName.text = pokemon?.name.capitalized ?? "Pokémon"
        pokemonWeight.text = "\(pokemon?.weight ?? 0)Kg"
        pokemonHeight.text = "\(pokemon?.height ?? 0)m"

        if let pokemonType1 = pokemon?.types[0] {
            pokemonFirstType.setTitle(pokemonType1.capitalized, for: .normal)
        }
        if (pokemon?.types.count == 2) {
            if let pokemonType2 = pokemon?.types[1] {
                pokemonSecondType.setTitle(pokemonType2.capitalized, for: .normal)
            }
        } else {
            pokemonSecondType.isHidden = true
        }
        // Not all Pokemons can have 3 attacks - needs to be optional
        pokemonFirstAttack.text = pokemon?.moves[0].capitalized
        pokemonSecondAttack.text = pokemon?.moves[1].capitalized
        pokemonThirdAttack.text = pokemon?.moves[2].capitalized
        if let baseHP = pokemon?.baseHP {
            hpLabel.text = "\(baseHP)"
        }
        if let baseAttack = pokemon?.baseAttack {
            attackLabel.text = "\(baseAttack)"
        }
        if let baseDefense = pokemon?.baseDefense {
            defenseLabel.text = "\(baseDefense)"
        }
        if let baseSpAttack = pokemon?.baseSpAttack {
            spAtkLabel.text = "\(baseSpAttack)"
        }
        if let baseSpDefense = pokemon?.baseSpeed {
            spDefLabel.text = "\(baseSpDefense)"
        }
        if let baseSpeed = pokemon?.baseSpeed {
            speedLbl.text = "\(baseSpeed)"
        }
    }
}
