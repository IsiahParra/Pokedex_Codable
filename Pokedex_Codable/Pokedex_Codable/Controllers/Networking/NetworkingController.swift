//
//  NetworkingController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation
import UIKit.UIImage

struct NetworkingController {
    
    private static let baseURLString = "https://pokeapi.co"
    
    //MARK: EndPoint 1
    static func fetchPokedex(with url: URL, completion: @escaping (Result<Pokedex, ResultError>) -> Void ) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                print("Encountered Error: \(error.localizedDescription)")
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let pokedex = try JSONDecoder().decode(Pokedex.self, from: data)
                completion(.success(pokedex))
            }catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    //MARK: EndPoint 2
    static func fetchPokemon(with pokemonURLString: String, completion: @escaping (Result<Pokemon,ResultError>) -> Void) {
        
        guard let finalURL = URL(string: pokemonURLString) else {completion(.failure(.invalidURL(URL(string: pokemonURLString)!)))
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            if let error = error {
                print("Encountered error: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return}
            
            do {
                // TODO: DEcode the object
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: pokemonData)
                completion(.success(pokemon))
            } catch {
                print("Encountered error when decoding the data:", error.localizedDescription)
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    //MARK: END POINT 3
    static func fetchImage(for pokemon: String, completetion: @escaping (Result<UIImage, ResultError>) -> Void) {
        guard let imageURL = URL(string: pokemon) else {
            completetion(.failure(.invalidURL(URL(string: pokemon)!)))
            return}
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("There was an error", error.localizedDescription)
                completetion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completetion(.failure(.noData))
                return
            }
            let pokemonImage = UIImage(data: data)
            completetion(.success(pokemonImage!))
        }.resume()
    }
}// end
