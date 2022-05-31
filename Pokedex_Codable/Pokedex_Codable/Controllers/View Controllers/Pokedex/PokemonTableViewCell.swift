//
//  PokemonTableViewCell.swift
//  Pokedex_Codable
//
//  Created by Isiah Parra on 5/31/22.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
// MARK: OUTLETS
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIdLabel: UILabel!
   
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonSpriteImageView.image = nil
    }
    
    func updateViews(with urlString: String) {
        // fetch the single pokemon data
        NetworkingController.fetchPokemon(with: urlString) { [weak self] result in
            switch result {
            case.success(let pokemon):
                self?.fetchImage(for: pokemon)
            case.failure(let error):
                print("There was an error.", error.errorDescription!)
            }
        }
    }
    
    func fetchImage(for pokemon: Pokemon) {
        NetworkingController.fetchImage(for: pokemon.sprites.frontShiny) { [weak self] result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    self?.pokemonNameLabel.text = pokemon.name
                    self?.pokemonIdLabel.text = "No: \(pokemon.id)"
                    self?.pokemonSpriteImageView.image = image
                }
            case.failure(let error):
                print("there was an error!", error.errorDescription!)
            }
        }
    }

}// End of class
