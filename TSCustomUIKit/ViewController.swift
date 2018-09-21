//
//  ViewController.swift
//  TSCustomUIKit
//
//  Created by huangyuchen on 2018/7/15.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var i = 0
    var inputTextView = TSTextFieldView.init(frame: .zero)
    var mainTableView = UITableView.init(frame: .zero, style: .plain)
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton.init(frame: CGRect.init(x: 50, y: 50, width: 50, height: 50))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        inputTextView.limitEmoji = true
//        inputTextView.limitMarkChar = true
        inputTextView.textColor = .red
        inputTextView.limitLenght = 10
        inputTextView.backgroundColor = .cyan
        view.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(50.ts.scale())
        }
        let aaa = "123123444".dropLast(100)
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(20)
            make.bottom.equalToSuperview()
        }
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsVerticalScrollIndicator = false

        count = arc4random_uniform(1) == 0 ? 0 : 10
        let emptyView = UIView()
        view.ts_emptyView = emptyView
        emptyView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        let noNetView = UIView()
        view.ts_noNetworkView = noNetView
        noNetView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        let emV = TSTestEmptyView.init(frame: .zero)
        mainTableView.tsNormalEmptyView(#imageLiteral(resourceName: "dropdown_anim.png"), "暂时没有数据哦")
        mainTableView.ts_emptyView!.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        emV.onClickA = { [weak self] in
            let count = arc4random_uniform(4)
            self?.count = count == 1 ? 0 : 10
            if count == 3 {
                self?.count = 0
                self?.mainTableView.ts_showNoNetwork()
            } else {
                self?.reloadTab()
            }
        }
//        mainTableView.viewCanScroll = false
        
        let noNet = TSTestNoNetView.init(frame: .zero)

        noNet.reloadNet = { [weak self] in
            let count = arc4random_uniform(2)
            self?.count = count == 1 ? 0 : 10
//            if self?.count == 10 {
//                self?.mainTableView.removeAllStateView()
//            }
            self?.reloadTab()
        }
        mainTableView.tsNormalNonetWorkView(#imageLiteral(resourceName: "dropdown_anim.png"), "刷新") { [weak self] in
            let count = arc4random_uniform(2)
             self?.count = count == 1 ? 0 : 10
            self?.mainTableView.ts_hiddenAllStateView()
            self?.reloadTab()
        }
        mainTableView.ts_noNetworkView!.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        count = 10
        reloadTab()
        print("\(aaa)")
    }

    func reloadTab() {
        if count == 0 {
            mainTableView.ts_showNoNetwork()
        }
        mainTableView.reloadData()
//        mainTableView.reloadEmptyStateView()
    }
    
    @objc func buttonClick() -> Void {
        
        if i == 0 {
            
            TSToastControl.showToast("w")
        }else{
            
            TSToastControl.showToast("asdfadfasdfadfasdf")
        }
        
        i = i + 1
//        ts_toastControl.animationStyle = .upDownAndFade
//        TSToastControl.showToast("asdfadfasdfadfasdf")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sss")
        if !(cell != nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "sss")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        count = 0
        reloadTab()
    }
    
}

