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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        // Add bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForanswer))
        
        // choose file destination
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // check if we have content in it
            if let startWords = try? String(contentsOf: startWordsURL){
                // put this content into array
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
    
    // reload tableview and clear the array of used words
    @objc func startGame() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForanswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            // parameters we send into
            [weak self, weak ac] _ in
            // closure body
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                } else {
                    showErrorMessage(title: "Word not recognized", message: "You need to try another word")
                }
            } else {
                showErrorMessage(title: "Word not possible", message: "You already used this word")
            }
        } else {
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title!.lowercased())")
        }
    }
    
    func showErrorMessage(title errorTitle: String, message errorMessage: String) {
        
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        
        if word == "" || word == " " {
            print("spaces")
            return false
        }
        
        if word == title {
            print("== title")
            return false
        }
        
        if word.count < 3 {
            print("< 3")
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        // UI Kit text checker
        let checker = UITextChecker()
        // set range from 0 to word length. Loop over each letter
        let range = NSRange(location: 0, length: word.utf16.count)
        // checks misspelled words
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // NSNotFound is a special Int, which means literally nothing found
        return misspelledRange.location == NSNotFound
    }
}

