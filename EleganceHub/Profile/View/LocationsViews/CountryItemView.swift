//
//  CountryItemView.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit

class CountryItemView: UIView {
    @IBOutlet weak var countryNameLable:UILabel!
    @IBOutlet weak var countryIcon:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commenInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commenInit()
    }
    
    private func commenInit(){
        let bundle = Bundle.init(for: CountryItemView.self)
        if let viewToAdd = bundle.loadNibNamed("CountryItemView", owner: self,options: nil), let contentView = viewToAdd.first as?UIView{
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
    }

}
