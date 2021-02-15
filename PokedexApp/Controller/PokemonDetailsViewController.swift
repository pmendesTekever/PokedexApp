import UIKit

class PokemonDetailsViewController: UIViewController {
    
    var pokemon: PokemonModel? = nil
    
    @IBOutlet weak var CPLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var detailsFirstSection: UIView!
    @IBOutlet weak var detailsSecondSection: UIView!
    @IBOutlet weak var detailsThirdSection: UIView!
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
    
    private let detailCornerRadius: CGFloat =  10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        self.setDetailCornerRadius()
        
        self.setPokemonDetails()
        self.setPokemonTypes()
        self.setPokemonAttacks()
        self.setPokemonBaseStats()
    }
    
    func setDetailCornerRadius() {
        detailsFirstSection.layer.cornerRadius = detailCornerRadius
        detailsSecondSection.layer.cornerRadius = detailCornerRadius
        detailsThirdSection.layer.cornerRadius = detailCornerRadius
    }
    
    func setPokemonDetails() {
        if pokemon?.artwork != nil {
            pokemonImage.image = UIImage(data: (pokemon?.artwork)!)
        }
        pokemonName.text = pokemon?.name.capitalized ?? "Pokémon"
        pokemonWeight.text = "\(pokemon?.weight ?? 0)Kg"
        pokemonHeight.text = "\(pokemon?.height ?? 0)"
    }
    
    func setPokemonTypes() {
        if let pokemonType1 = pokemon?.types[0] {
            pokemonFirstType.setTitle(pokemonType1.capitalized, for: .normal)
        }
        if (pokemon?.types.count == 2), let pokemonType2 = pokemon?.types[1] {
            pokemonSecondType.setTitle(pokemonType2.capitalized, for: .normal)
        } else {
            pokemonSecondType.isHidden = true
        }
    }
    
    func setPokemonAttacks() {
        if let firstAttack = pokemon?.moves[0], firstAttack != "" {
          pokemonFirstAttack.text = firstAttack.capitalized
        } else {
          pokemonFirstAttack.text = "Struggle"
        }
        if let secondAttack = pokemon?.moves[1], secondAttack != "" {
          pokemonSecondAttack.text = secondAttack.capitalized
        } else {
            pokemonSecondAttack.isHidden = true
        }
        if let thirdAttack = pokemon?.moves[2], thirdAttack != "" {
          pokemonFirstAttack.text = thirdAttack.capitalized
        } else {
            pokemonThirdAttack.isHidden = true
        }
    }
    
    func setPokemonBaseStats() {
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
        if let totalCP = pokemon?.totalCP {
            CPLabel.text = "CP \(totalCP)"
        }
    }
}
