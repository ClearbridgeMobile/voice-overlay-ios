//
//  ViewController.swift
//  VoiceUI
//
//  Created by Guy Daher on 20/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class PermissionViewController: UIViewController {
    
    var dismissHandler: (() -> ())? = nil
    var speechController: Recordable!
  
    var constants: PermissionScreenConstants!
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let rejectMicrophoneAccessButton = UIButton()
        let allowMicrophoneAccessButton = UIButton()
        let closeButton = UIButton()
        let titleContainerView = UIView()
        let subtitleContainerView = UIView()
        
        view.backgroundColor = UIColor(named: "greenBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let subViews = [closeButton, titleContainerView, subtitleContainerView, allowMicrophoneAccessButton, rejectMicrophoneAccessButton]
        ViewHelpers.translatesAutoresizingMaskIntoConstraintsFalse(for: subViews)
        ViewHelpers.addSubviews(for: subViews, in: view)
        
        // rejectMicrophoneAccessButton
        rejectMicrophoneAccessButton.setTitle(constants.rejectText, for: .normal)
        rejectMicrophoneAccessButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)
        rejectMicrophoneAccessButton.layer.cornerRadius = 25
        rejectMicrophoneAccessButton.layer.masksToBounds = true
        rejectMicrophoneAccessButton.layer.borderWidth = 1
        rejectMicrophoneAccessButton.layer.borderColor = UIColor.white.cgColor

        NSLayoutConstraint.activate([
            rejectMicrophoneAccessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            rejectMicrophoneAccessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            rejectMicrophoneAccessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rejectMicrophoneAccessButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -111),
            rejectMicrophoneAccessButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // allowMicrophoneAccessButton
        allowMicrophoneAccessButton.setTitle(constants.allowText, for: .normal)
        allowMicrophoneAccessButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 18)

        allowMicrophoneAccessButton.backgroundColor = UIColor(named: "buttonYellowBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
        allowMicrophoneAccessButton.layer.cornerRadius = 25
        allowMicrophoneAccessButton.layer.masksToBounds = true
        allowMicrophoneAccessButton.setTitleColor(UIColor(named: "buttonText", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)

        NSLayoutConstraint.activate([
            allowMicrophoneAccessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            allowMicrophoneAccessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            allowMicrophoneAccessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            allowMicrophoneAccessButton.bottomAnchor.constraint(equalTo: rejectMicrophoneAccessButton.topAnchor, constant: -22),
            allowMicrophoneAccessButton.heightAnchor.constraint(equalToConstant: 50)
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
        


//        ViewHelpers.setConstraintsForTitleLabel(titleLabel, margins, constants.title, constants.textColor)
//        ViewHelpers.setConstraintsForSubtitleLabel(subtitleLabel, titleLabel, margins, constants.subtitle, constants.textColor)
//        ViewHelpers.setConstraintsForFirstButton(allowMicrophoneAccessButton, margins, constants.allowText, constants.textColor)
        //ViewHelpers.setConstraintsForSecondButton(rejectMicrophoneAccessButton, allowMicrophoneAccessButton, margins, constants.rejectText, constants.textColor)

        allowMicrophoneAccessButton.addTarget(self, action: #selector(allowMicrophoneTapped), for: .touchUpInside)
        rejectMicrophoneAccessButton.addTarget(self, action: #selector(rejectMicrophoneTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func allowMicrophoneTapped() {
        
        speechController.requestAuthorization { _ in
            AVAudioSession.sharedInstance().requestRecordPermission({ (isGranted) in
                DispatchQueue.main.async {                                                     
                    self.dismissMe(animated: true) {
                        self.dismissHandler?()
                    }
                }
            })
        }
    }
  
    public override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      //titleLabel.preferredMaxLayoutWidth = self.view.frame.width - VoiceUIInternalConstants.sideMarginConstant * 2
      //subtitleLabel.preferredMaxLayoutWidth = self.view.frame.width - VoiceUIInternalConstants.sideMarginConstant * 2
      self.view.layoutIfNeeded()
    }
    
    @objc func rejectMicrophoneTapped() {
        dismissMe(animated: true)
    }
    
    @objc func closeButtonTapped(_ sender: UITapGestureRecognizer) {
        dismissMe(animated: true)
    }

}
