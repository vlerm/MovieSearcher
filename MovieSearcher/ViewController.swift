//
//  ViewController.swift
//  MovieSearcher
//
//  Created by Вадим Лавор on 15.03.22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
    }
    
    func searchMovies() {
        textField.resignFirstResponder()
        guard let text = textField.text, !text.isEmpty else {return}
        let query = text.replacingOccurrences(of: "", with: "%20")
        movies.removeAll()
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=\(query)&type=movie")!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {return}
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data )
                } catch {
                    print("error")
                }
            guard let finalResult = result else {return}
            let newMovies = finalResult.Search
            self.movies.append(contentsOf: newMovies)
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }).resume()
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
}
    
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        present(safariViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

