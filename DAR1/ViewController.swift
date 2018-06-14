//
//  ViewController.swift
//  DAR1
//
//  Created by Arthur Belyankov on 11.06.2018.
//  Copyright © 2018 Arthur Belyankov. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CellDelegate {
    
    var array = [Model]()
    var tapindx: [IndexPath: Bool] = [:]
    
    var tableview : UITableView = {
        let tableview = UITableView()
        
        tableview.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableview.scrollsToTop = true
        tableview.separatorColor = .white
        return tableview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        View_1()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationItem.title = "Downloadr"
        navigationController?.navigationBar.barTintColor = .black
        Modelcall()
    }
    
    func View_1(){
        view.addSubview(tableview)
        
        tableview.snp.makeConstraints{(make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.name.text = array[indexPath.row].title
        cell.artist.text = array[indexPath.row].author
        cell.urlData = array[indexPath.row].url
        cell.namefile = array[indexPath.row].title
        cell.delegate = self
        if let _ = tapindx[indexPath]{
            cell.state = array[indexPath.row].type
//            cell.state = 2
        }else{
            cell.state = 1
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    func Modelcall(){
        Model.Songs{(cats) in
            self.array = cats
            self.tableview.reloadData()
        }
    }
    
    func didTap(_ cell: TableViewCell) {
        
        let indexPath = self.tableview.indexPath(for: cell)!
        
        if let actionname = cell.BTN.titleLabel?.text {
            if let _ = tapindx[indexPath] {
                if actionname == "Удалить"{
                    Download.instance.DeleteSong(namefile: array[indexPath.row].title)
                    cell.state = 1
                    tapindx.removeValue(forKey: indexPath)}
            }else {
                if actionname == "Скачать"{
                    print("hell") 
                    self.array[indexPath.row].type = 2
                    cell.state = 2
                    Download.instance.DownloadAudio(url: self.array[indexPath.row].url, namefile: array[indexPath.row].title){(progress) in
                        cell.progressview.setProgress(progress, animated: true)
                        
                        if cell.progressview.progress == 1.0 {
                            self.array[indexPath.row].type = 3
                            self.tableview.reloadData()
                        }
                    }
                    tapindx[indexPath] = true
                }
            }
            self.tableview.reloadData()
        }
    }
}
