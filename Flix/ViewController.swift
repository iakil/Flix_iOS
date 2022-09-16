//
//  ViewController.swift
//  Flix
//
//  Created by Akil Bhuiyan on 9/16/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    //create dictionary of key of type String to value of type Any.
    
    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              self.movies = dataDictionary["results"] as! [[String: Any]]
            
            self.tableView.reloadData()
           }
        }
        task.resume()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string:baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        return cell
    }
    
    //In a storyboard-based app, you'll want to do some preparation before navigation takes place.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get new view controller using segue.destination
        //Pass selected object to new  view controller
        
        //Find selected movie cell.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
    
        //Pass selected movie to details view controller.
        //need to cast as DetailsViewController, otherwise segue.destination will return a generic view controller not our custom one.
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.movie = movie
        
        //twitter does this actually.
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

