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
    }

}
