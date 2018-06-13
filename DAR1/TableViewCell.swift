//
//  TableViewCell.swift
//  DAR1
//
//  Created by Arthur Belyankov on 11.06.2018.
//  Copyright © 2018 Arthur Belyankov. All rights reserved.
//

import UIKit
import Alamofire
class TableViewCell: UITableViewCell {
    
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
    
    var btn: UIButton = {
        let btn1 = UIButton()
        btn1.setTitleColor(.red, for: .normal)
        btn1.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        return btn1
    }()
    
    var btn1: UIButton = {
        let btn1 = UIButton()
        btn1.setTitleColor(.red, for: .normal)
        btn1.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        return btn1
    }()
    
    var progressview: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.progress = 0
        return progressView
    }()
    
    var time : Float = 0.0
    var timer: Timer?
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
        self.addSubview(btn)
        btn.addTarget(self, action: #selector(BTNdownload), for: .touchUpInside)
        btn.setTitle("Скачать", for: .normal)
        btn.snp.makeConstraints{(make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-10)
            make.height.equalTo(10)
            make.width.equalTo(110)
        }
        self.addSubview(btn1)
        btn1.isHidden = true
        btn1.addTarget(self, action: #selector(BTNdelete), for: .touchUpInside)
        btn1.setTitle("Удалить", for: .normal)
        btn1.snp.makeConstraints{(make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-10)
            make.height.equalTo(10)
            make.width.equalTo(110)
        }
        self.addSubview(progressview)
        progressview.isHidden = true
        progressview.snp.makeConstraints{(make) in
            make.top.equalTo(artist.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(3)
        }
    }
    @objc func BTNdownload(){
        print("Start download")
        btn.setTitle("Идёт загрузка", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        time = 0.0
        progressview.isHidden = false
        progressview.setProgress(0.0, animated: true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(BTNprogress), userInfo: nil, repeats: true)
        ParseIndex(url: urlData, namefile: namefile)
    }
    
    
    func ParseIndex (url: String!, namefile: String){
         let encode = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let destination: DownloadRequest.DownloadFileDestination = {_,_  in
            var docurl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            docurl.appendPathComponent(namefile)
            return (docurl, [.removePreviousFile])
        }
    
        Alamofire.download(encode!, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                self.progressview.progress = Float(progress.fractionCompleted)
            }
            .responseData { response in
                if response.result.value != nil {
                }
        }
    }
    
    @objc func BTNprogress(){
        if progressview.progress == 1.0{
            timer!.invalidate()
            print("Done")
            progressview.isHidden = true
            btn.isHidden = true
            btn1.isHidden = false
        }
        time += 1.0
    }
    
    @objc func BTNdelete(){
        btn1.isHidden = true
        btn.isHidden = false
        btn.setTitle("Скачать", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(namefile)
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationPath) {
                try fileManager.removeItem(atPath: destinationPath)
                print("Delete Done")
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}

