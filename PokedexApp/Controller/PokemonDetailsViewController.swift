import UIKit

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var topImageView: UIView!
    @IBOutlet weak var fullDetailsStackView: UIStackView!
    @IBOutlet weak var pokemonDetailStackView: UIStackView!
    @IBOutlet weak var detailsFirstSection: UIView!
    @IBOutlet weak var detailsSecondSection: UIView!
    @IBOutlet weak var detailsThirdSection: UIView!
    @IBOutlet weak var buttonCPStackView: UIStackView!
    
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
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private let detailCornerRadius: CGFloat =  10
    var pokemon: PokemonModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        self.setDetailCornerRadius()
        
        self.setPokemonDetails()
        self.setPokemonTypes()
        self.setPokemonAttacks()
        self.setPokemonBaseStats()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let margins = view.layoutMarginsGuide
        if UIDevice.current.orientation.isLandscape {
            pokemonDetailStackView.axis = .horizontal
            fullDetailsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 10).isActive = true
        } else {
            pokemonDetailStackView.axis = .vertical
        }
    }
    
    func setDetailCornerRadius() {
        detailsFirstSection.layer.cornerRadius = detailCornerRadius
        detailsFirstSection.layer.shadowColor = UIColor.gray.cgColor
        detailsFirstSection.layer.shadowOpacity = 1
        detailsFirstSection.layer.shadowOffset = .zero
        detailsFirstSection.layer.shadowRadius = 8

        detailsSecondSection.layer.cornerRadius = detailCornerRadius
        detailsSecondSection.layer.shadowColor = UIColor.gray.cgColor
        detailsSecondSection.layer.shadowOpacity = 1
        detailsSecondSection.layer.shadowOffset = .zero
        detailsSecondSection.layer.shadowRadius = 8
        
        detailsThirdSection.layer.cornerRadius = detailCornerRadius
        detailsThirdSection.layer.shadowColor = UIColor.gray.cgColor
        detailsThirdSection.layer.shadowOpacity = 1
        detailsThirdSection.layer.shadowOffset = .zero
        detailsThirdSection.layer.shadowRadius = 8
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
        if pokemon?.moves != nil {
            let movesCount = pokemon!.moves.count
            switch movesCount {
            case 1:
                pokemonFirstAttack.text = pokemon?.moves[0].capitalized
                pokemonSecondAttack.isHidden = true
                pokemonThirdAttack.isHidden = true
                break
            case 2:
                pokemonFirstAttack.text = pokemon?.moves[0].capitalized
                pokemonSecondAttack.text = pokemon?.moves[1].capitalized
                pokemonThirdAttack.isHidden = true
                break
            case 3:
                pokemonFirstAttack.text = pokemon?.moves[0].capitalized
                pokemonSecondAttack.text = pokemon?.moves[1].capitalized
                pokemonThirdAttack.text = pokemon?.moves[2].capitalized
                break
            default:
                pokemonFirstAttack.text = "Struggle"
            }
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
