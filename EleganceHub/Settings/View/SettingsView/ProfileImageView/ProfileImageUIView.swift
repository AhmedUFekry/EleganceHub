//
//  ProfileImageUIView.swift
//  EleganceHub
//
//  Created by AYA on 31/05/2024.
//

import UIKit

class ProfileImageUIView: UIView {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editPicBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commenInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commenInit()
    }
    
    private func commenInit(){
        let bundle = Bundle.init(for: ProfileImageUIView.self)
        if let viewToAdd = bundle.loadNibNamed("ProfileImageUIView", owner: self,options: nil), let contentView = viewToAdd.first as?UIView{
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            self.profileImage.layer.cornerRadius = 10
            self.profileImage.layer.shadowColor = UIColor.black.cgColor
            self.profileImage.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.profileImage.layer.shadowRadius = 4
            self.profileImage.layer.shadowOpacity = 0.5
          self.profileImage.layer.masksToBounds = true
            
            self.editPicBtn.layer.cornerRadius = 10
            self.editPicBtn.layer.shadowColor = UIColor.black.cgColor
            self.editPicBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.editPicBtn.layer.shadowRadius = 4
            self.editPicBtn.layer.shadowOpacity = 0.7
            self.editPicBtn.layer.masksToBounds = false
            self.layer.masksToBounds = false
        }
    }
}
