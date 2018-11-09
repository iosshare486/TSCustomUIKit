

//
//  TSTestSegmentViewController.swift
//  TSCustomUIKit
//
//  Created by huangyuchen on 2018/10/22.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

class TSTestSegmentViewController: UIViewController {

    private var segmentedControl: TSSegmentedControlPlus!
    
    private var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl = TSSegmentedControlPlus(frame: CGRect.zero, titleArray: [])
        segmentedControl.alignment = .center
//        segmentedControl.delegate = self
        segmentedControl.dataSource = self
        self.view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(50.ts.scale())
        }
        
        segmentedControl.segmentControlInstall()
        
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonOnClick), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func buttonOnClick() {
        var titles = [TSSegmentedControlPlusTitleItem]()
        for i in 0..<10 {
            
            let item1 = TSSegmentedControlPlusTitleItem()
            item1.normalTitle = "标题\(i)"
            item1.normalColor = .red
            item1.normalBackgroundImage = UIImage.init(color: 0x9.ts.color())
            item1.selectBackgroundImage = UIImage.init(color: 0xf.ts.color())
            titles.append(item1)
        }
        segmentedControl.segmentControlReload(titleArray: titles)
    }
    
}

extension TSTestSegmentViewController: TSSegmentedControlPlusDataSource {
    
    func segmentedControlPlusItemSize(index: Int) -> CGSize {
        return CGSize(width: 50, height: 30.ts.scale())
    }
}
