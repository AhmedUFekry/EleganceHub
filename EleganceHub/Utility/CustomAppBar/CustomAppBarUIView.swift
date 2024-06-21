//
//  CustomAppBarUIView.swift
//  EleganceHub
//
//  Created by AYA on 01/06/2024.
//

import UIKit

class CustomAppBarUIView: UIView {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var trailingIcon: UIButton!
    @IBOutlet weak var secoundTrailingIcon: UIButton!
    @IBOutlet weak var lableTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commenInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commenInit()
    }
    
    private func commenInit(){
        let bundle = Bundle.init(for: CustomAppBarUIView.self)
        if let viewToAdd = bundle.loadNibNamed("customAppBarUIView", owner: self,options: nil), let contentView = viewToAdd.first as?UIView{
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        applyShadow()
        //setUpBtnsThemes()
    }
    private func applyShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
        
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: self.bounds.height - self.layer.shadowRadius, width: self.bounds.width, height: self.layer.shadowRadius))
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func setUpBtnsThemes(){
        let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if isDarkMode{
            backBtn.setImage(UIImage(named: "backLight"), for: .normal)
            
        }else{
            backBtn.setImage(UIImage(named: "back"), for: .normal)
        }
    }
}
