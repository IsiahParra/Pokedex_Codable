//
//  PokedexTableViewController.swift
//  Pokedex_Codable
//
//  Created by Isiah Parra on 5/31/22.
//

import UIKit

class PokedexTableViewController: UITableViewController {
    var pokedex: [ResultsDictionary] = []
    var topLevelPokedex: Pokedex?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: ENDPOINT 1
        
        NetworkingController.fetchPokedex(with: URL(string: "https://pokeapi.co/api/v2/pokemon")!) { [weak self] result in
            switch result {
            case.success(let pokedex):
                self?.pokedex = pokedex.results
                self?.topLevelPokedex = pokedex
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    
                }
            case.failure(let error):
                print("Oh no! Theres been an error!", error.errorDescription!)
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokedex.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as? PokemonTableViewCell else {return UITableViewCell()}
        let pokemon = pokedex[indexPath.row]
        cell.updateViews(with: pokemon.url)
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastPokedexIndex = pokedex.count - 1
        guard let topLevelPokedex = topLevelPokedex,
              let nextURL = URL(string: topLevelPokedex.next)
        else {return}
        if indexPath.row == lastPokedexIndex {
        NetworkingController.fetchPokedex(with: nextURL) { result in
            switch result {
            case.success(let pokedex):
                DispatchQueue.main.async {
                self.topLevelPokedex = pokedex
                    self.pokedex.append(contentsOf: pokedex.results)
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }

    }
}
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokedexVC" {
            if let index = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? PokemonViewController {
                    let pokemonToSend = pokedex[index.row]
                    NetworkingController.fetchPokemon(with: pokemonToSend.url) { results in
                        switch results {
                        case.success(let pokemon):
                            DispatchQueue.main.async {
                                destination.pokemon = pokemon
                            }
                        case.failure(let error):
                            print("Theres been an error!", error.errorDescription!)
                        }
                    }
                }
            }
        }
    }
    

}// end of class
