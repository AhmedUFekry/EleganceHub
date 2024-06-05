//
//  SettingsProfileView.swift
//  EleganceHub
//
//  Created by AYA on 01/06/2024.
//

import UIKit

class SettingsProfileView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commenInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commenInit()
    }
    
    private func commenInit(){
        let bundle = Bundle.init(for: SettingsProfileView.self)
        if let viewToAdd = bundle.loadNibNamed("SettingsProfileView", owner: self,options: nil), let contentView = viewToAdd.first as?UIView{
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
}
