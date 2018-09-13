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
        
        print("\(aaa)")
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

