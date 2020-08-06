//
//  NoPermissionViewController.swift
//  VoiceOverlay
//
//  Created by Guy Daher on 28/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public class NoPermissionViewController: UIViewController {
    
    var dismissHandler: (() -> ())? = nil
    var constants: NoPermissionScreenConstants!
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
  
  
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let margins = view.layoutMarginsGuide

        let doneWithSettingsButton = UIButton()
        let goToSettingsButton = UIButton()
        let closeButton = UIButton()
        let titleContainerView = UIView()
        let subtitleContainerView = UIView()
        
        let subViews = [titleContainerView, subtitleContainerView, goToSettingsButton, doneWithSettingsButton, closeButton]
        
        ViewHelpers.translatesAutoresizingMaskIntoConstraintsFalse(for: subViews)
        ViewHelpers.addSubviews(for: subViews, in: view)
        
         view.backgroundColor = UIColor(named: "greenBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
         ViewHelpers.translatesAutoresizingMaskIntoConstraintsFalse(for: subViews)
         ViewHelpers.addSubviews(for: subViews, in: view)
         
         // doneWithSettingsButton
         doneWithSettingsButton.setTitle(constants.doneText, for: .normal)
         doneWithSettingsButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)
         doneWithSettingsButton.layer.cornerRadius = 25
         doneWithSettingsButton.layer.masksToBounds = true
         doneWithSettingsButton.layer.borderWidth = 1
         doneWithSettingsButton.layer.borderColor = UIColor.white.cgColor

         NSLayoutConstraint.activate([
             doneWithSettingsButton.widthAnchor.constraint(equalToConstant: 350),
             doneWithSettingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             doneWithSettingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -111),
             doneWithSettingsButton.heightAnchor.constraint(equalToConstant: 50)
         ])

         // allowMicrophoneAccessButton
        goToSettingsButton.setTitle(constants.permissionEnableText, for: .normal)
         goToSettingsButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)

         goToSettingsButton.backgroundColor = UIColor(named: "buttonYellowBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
         goToSettingsButton.layer.cornerRadius = 25
         goToSettingsButton.layer.masksToBounds = true
         goToSettingsButton.setTitleColor(UIColor(named: "buttonText", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)

         NSLayoutConstraint.activate([
             goToSettingsButton.widthAnchor.constraint(equalToConstant: 350),
             goToSettingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             goToSettingsButton.bottomAnchor.constraint(equalTo: doneWithSettingsButton.topAnchor, constant: -22),
             goToSettingsButton.heightAnchor.constraint(equalToConstant: 50)
         ])
         
        // closeButton
         closeButton.setImage(UIImage(named: "Close"), for: .normal)
         
         NSLayoutConstraint.activate([
             closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
             closeButton.heightAnchor.constraint(equalToConstant: 20),
             closeButton.widthAnchor.constraint(equalToConstant: 20)
         ])

         // title
         titleContainerView.backgroundColor = UIColor(named: "labelBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
         titleLabel.numberOfLines = 0
         titleLabel.textAlignment = .left
         titleLabel.lineBreakMode = .byWordWrapping
         titleLabel.text = constants.title
         titleLabel.textColor = .white
         titleLabel.font = UIFont(name: "Montserrat-Regular", size: 17)
         
         titleLabel.translatesAutoresizingMaskIntoConstraints = false
         titleContainerView.translatesAutoresizingMaskIntoConstraints = false

         titleContainerView.addSubview(titleLabel)

         NSLayoutConstraint.activate([
             titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 8),
             titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: 6),
             titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -8),
             titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: -6)
         ])
         
         NSLayoutConstraint.activate([
             titleContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
             titleContainerView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 39),
             titleContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -19)
         ])
         
         // subtitle
         subtitleContainerView.backgroundColor = UIColor(named: "labelBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
         subtitleLabel.numberOfLines = 0
         subtitleLabel.textAlignment = .left
         subtitleLabel.lineBreakMode = .byWordWrapping
         subtitleLabel.text = constants.subtitle
         subtitleLabel.textColor = .white
         subtitleLabel.font = UIFont.systemFont(ofSize: 15)

         subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
         subtitleContainerView.translatesAutoresizingMaskIntoConstraints = false

         subtitleContainerView.addSubview(subtitleLabel)

         NSLayoutConstraint.activate([
             subtitleLabel.leadingAnchor.constraint(equalTo: subtitleContainerView.leadingAnchor, constant: 8),
             subtitleLabel.topAnchor.constraint(equalTo: subtitleContainerView.topAnchor, constant: 6),
             subtitleLabel.trailingAnchor.constraint(equalTo: subtitleContainerView.trailingAnchor, constant: -8),
             subtitleLabel.bottomAnchor.constraint(equalTo: subtitleContainerView.bottomAnchor, constant: -6)
         ])

         NSLayoutConstraint.activate([
             subtitleContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
             subtitleContainerView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: 18),
             subtitleContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -19)
         ])
        
        goToSettingsButton.addTarget(self, action: #selector(goToSettingsTapped), for: .touchUpInside)
        doneWithSettingsButton.addTarget(self, action: #selector(doneWithSettingsTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonTapped(_:)))
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
  
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //titleLabel.preferredMaxLayoutWidth = self.view.frame.width - VoiceUIInternalConstants.sideMarginConstant * 2
        //subtitleLabel.preferredMaxLayoutWidth = self.view.frame.width - VoiceUIInternalConstants.sideMarginConstant * 2
        self.view.layoutIfNeeded()
    }
    
    @objc func goToSettingsTapped() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                
            })
        }
    }
    
    @objc func doneWithSettingsTapped() {
        dismissMe(animated: true) {
            self.dismissHandler?()
        }
    }
    
    @objc func closeButtonTapped(_ sender: UITapGestureRecognizer) {
        dismissMe(animated: true)
    }
    
}
