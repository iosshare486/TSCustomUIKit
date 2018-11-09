

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = TSSegmentedControlPlusTitleItem()
        item1.normalTitle = "标题1"
        item1.normalBackgroundImage = UIImage.init(color: 0x9.ts.color())
        item1.selectBackgroundImage = UIImage.init(color: 0xf.ts.color())
        
        let item2 = TSSegmentedControlPlusTitleItem()
        item2.normalTitle = "标题2"
        item2.normalBackgroundImage = UIImage.init(color: 0x9.ts.color())
        item2.selectBackgroundImage = UIImage.init(color: 0xf.ts.color())
        
        let item3 = TSSegmentedControlPlusTitleItem()
        item3.normalTitle = "标题3"
        item3.normalBackgroundImage = UIImage.init(color: 0x9.ts.color())
        item3.selectBackgroundImage = UIImage.init(color: 0xf.ts.color())
        
        let item4 = TSSegmentedControlPlusTitleItem()
        item4.normalTitle = "标题4"
        item4.normalBackgroundImage = UIImage.init(color: 0x9.ts.color())
        item4.selectBackgroundImage = UIImage.init(color: 0xf.ts.color())
        
        segmentedControl = TSSegmentedControlPlus(frame: CGRect.zero, titleArray: [item1, item2, item3, item4])
        segmentedControl.alignment = .right
//        segmentedControl.delegate = self
        segmentedControl.dataSource = self
        self.view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(50.ts.scale())
        }
        
        segmentedControl.segmentControlInstall()
        
        
        // Do any additional setup after loading the view.
    }
    
}

extension TSTestSegmentViewController: TSSegmentedControlPlusDataSource {
    
    func segmentedControlPlusItemSize(index: Int) -> CGSize {
        return CGSize(width: 50.ts.scale(), height: 30.ts.scale())
    }
}
