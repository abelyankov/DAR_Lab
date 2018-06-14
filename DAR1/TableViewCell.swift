//
//  TableViewCell.swift
//  DAR1
//
//  Created by Arthur Belyankov on 11.06.2018.
//  Copyright © 2018 Arthur Belyankov. All rights reserved.
//

import UIKit
import Alamofire

protocol CellDelegate {
    func didTap(_ cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    var state = Int() {
        didSet{
            statusFunc(s: state)
        }
    }
    var delegate: CellDelegate?
    var downloader = Timer()
    
    var urlData: String!
    var namefile: String!
    
    var name: UILabel = {
        let label1 = UILabel()
        label1.textColor = .black
        label1.font = UIFont(name: "Helvetica", size: 19)
        return label1
    }()
    
    var artist: UILabel = {
        let label1 = UILabel()
        label1.textColor = UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        label1.font = UIFont.init(name: "Helvetica", size: 16)
        return label1
    }()
    
    var BTN: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        return btn
    }()

    var progressview: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.progress = 0
        return progressView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        Lable1()
    }
    
    func Lable1(){
        self.addSubview(name)
        name.snp.makeConstraints{(make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
        }
        
        self.addSubview(artist)
        artist.snp.makeConstraints{(make) in
            make.top.equalTo(name.snp.bottom)
            make.left.equalTo(name)
        }
        
        self.addSubview(BTN)
        BTN.addTarget(self, action: #selector(statusAction), for: .touchUpInside)
        BTN.snp.makeConstraints{(make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-10)
            make.height.equalTo(10)
            make.width.equalTo(110)
        }
        
        self.addSubview(progressview)
        progressview.snp.makeConstraints{(make) in
            make.top.equalTo(artist.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(3)
        }
    }
    
    @objc func statusAction(){
        delegate?.didTap(self)
        
    }

    func statusFunc(s: Int){
        switch s {
        case 1:
            BTN.setTitleColor(.red, for: .normal)
            BTN.setTitle("Скачать", for: .normal)
            progressview.isHidden = true
        case 2:
            BTN.setTitleColor(.blue, for: .normal)
            BTN.setTitle("Идет загрузка", for: .normal)
            progressview.isHidden = false
        case 3:
            BTN.setTitleColor(.red, for: .normal)
            BTN.setTitle("Удалить", for: .normal)
            progressview.isHidden = true
            downloader.invalidate()
        default:
            print("Error")
            
        }
    }
}
