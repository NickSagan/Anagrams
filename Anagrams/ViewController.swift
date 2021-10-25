//
//  ViewController.swift
//  Anagrams
//
//  Created by Nick Sagan on 25.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    let fl = FileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            } else {
                print("start.txt file was empty")
                allWords = ["Empty"]
            }
        } else {
            print("Can't find start.txt file")
            allWords = ["Empty"]
        }
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

