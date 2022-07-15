//
//  ViewController.swift
//  L10NTests
//
//  Created by ZhgChgLi on 2022/7/15.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleLabel.text = L10n.Localizable.homeSubTitle
        subTitleLabel.text = L10n.Localizable.homeSubTitle
        descriptionLabel.text = L10n.Localizable.homeDescription("zhgchgli")
        footerLabel.text = L10n.Footer.footerCopyright
        
    }


}

