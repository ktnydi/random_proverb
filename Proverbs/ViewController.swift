//
//  ViewController.swift
//  Proverbs
//
//  Created by Yudai Kitano on 2023/04/03.
//

import UIKit

class ViewController: UIViewController {
    var proverbs: [Proverb] = []
    @IBOutlet weak var proverbTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.proverbs = fetchProverbs()
        
        setupTableView()
    }
}

extension ViewController {
    func fetchProverbs() -> Array<Proverb> {
        guard let url = Bundle.main.url(forResource: "ProverbData", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let array = json as! [Any]
            let proverbs = array.map { item in
                let dictionary = item as! [String: Any]
                return Proverb(json: dictionary)
            }
            
            return proverbs
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        proverbTableView.dataSource = self
        proverbTableView.delegate = self
        
        // 一番上の区切り線を消す。
        proverbTableView.tableHeaderView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proverbs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let proverb = proverbs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProverbCell", for: indexPath)
        
        // 最後のセルの区切り線を消す。
        if (indexPath.row == proverbs.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        // セルの内容を定義する。
        var content = cell.defaultContentConfiguration()
        content.text = proverb.message
        content.textProperties.color = .label
        content.secondaryText = "\(proverb.movie), \(proverb.character), \(proverb.year)"
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
        
        return cell
    }
}
