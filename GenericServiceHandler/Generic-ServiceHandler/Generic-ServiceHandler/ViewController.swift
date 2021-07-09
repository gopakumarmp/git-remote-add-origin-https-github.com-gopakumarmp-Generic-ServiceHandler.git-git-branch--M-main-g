//
//  ViewController.swift
//  Generic-ServiceHandler
//
//  Created by Gopakumar MP on 7/8/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var countries:[Country] = [Country]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        fetch()

    }
    
    func fetch() {
        
        let url  = URL(string: "https://restcountries.eu/rest/v2/all")
        
        URLSession.shared.request(url: url, expecting: [Country].self) { [weak self] (result) in
            
            switch result {
            case .success(let countries):
                
                DispatchQueue.main.async {
                    self?.countries = countries
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Failed to get country list Err: \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = "\(self.countries[indexPath.row].name)  - \(self.countries[indexPath.row].capital) - [\(self.countries[indexPath.row].region)]"
        
        return cell
    }
}



