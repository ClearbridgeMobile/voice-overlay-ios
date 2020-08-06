//
//  ListeningViewController.swift
//  VoiceUI
//
//  Created by Guy Daher on 25/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class InputViewController: UIViewController {
  
  var speechController: Recordable?
  
  var speechTextHandler: SpeechTextHandler?
  var speechErrorHandler: SpeechErrorHandler?
  var speechResultScreenHandler: SpeechResultScreenHandler?
  weak var delegate: VoiceOverlayDelegate?
  
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let titleContainerView = UIView()
  let subtitleContainerView = UIView()
  let subtitleBulletLabel = UILabel()
  let closeView = CloseView()
  let recordingButton = RecordingButton()
  let tryAgainLabel = UILabel()
  let logo = UIImageView()
  
  var isRecording: Bool = false
  var autoStopTimer: Timer = Timer()
  
  var speechText: String?
  var customData: Any?
  var speechError: Error?
  
  var constants: InputScreenConstants!
  var settings: VoiceUISettings!
  
  //var resultViewController: ResultViewController?
  
  var dismissHandler: ((Bool) -> ())? = nil
  var resultScreentimer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let margins = view.layoutMarginsGuide
    
    let subViews = [logo, titleContainerView, subtitleContainerView, subtitleBulletLabel, closeView, recordingButton, tryAgainLabel]
    
    ViewHelpers.translatesAutoresizingMaskIntoConstraintsFalse(for: subViews)
    ViewHelpers.addSubviews(for: subViews, in: view)
    
    closeView.crossColor = constants.backgroundColor
    view.backgroundColor = constants.backgroundColor
    
    logo.image = UIImage(named: "Logo")
    logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    logo.heightAnchor.constraint(equalToConstant: 33).isActive = true
    logo.widthAnchor.constraint(equalToConstant: 120).isActive = true
    

    // title
    titleContainerView.backgroundColor = UIColor(named: "labelBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .left
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.text = constants.titleInitial
    titleLabel.textColor = .white
    titleLabel.font = UIFont(name: "Montserrat-Regular", size: 24)
    
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
        titleContainerView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 39),
        titleContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -19)
    ])
    
    // subtitle
    subtitleContainerView.backgroundColor = UIColor(named: "labelBackground", in: Bundle(for: type(of: self)), compatibleWith: nil)
    subtitleLabel.numberOfLines = 0
    subtitleLabel.textAlignment = .left
    subtitleLabel.lineBreakMode = .byWordWrapping
    subtitleLabel.text = constants.subtitleInitial
    subtitleLabel.textColor = .white
    subtitleLabel.font = UIFont.systemFont(ofSize: 18)

    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleContainerView.translatesAutoresizingMaskIntoConstraints = false

    subtitleContainerView.addSubview(subtitleLabel)
    subtitleContainerView.isHidden = true

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
    
    
    
    //ViewHelpers.setConstraintsForTitleLabel(titleLabel, margins, constants.titleInitial, constants.textColor)
    //ViewHelpers.setConstraintsForSubtitleLabel(subtitleLabel, titleLabel, margins, constants.subtitleInitial, constants.textColor)
    ViewHelpers.setConstraintsForSubtitleBulletLabel(subtitleBulletLabel, subtitleLabel, margins, constants.subtitleBulletList, constants.textColor)
    ViewHelpers.setConstraintsForCloseView(closeView, margins, backgroundColor: constants.backgroundColor)
    ViewHelpers.setConstraintsForRecordingButton(recordingButton, margins, recordingButtonConstants: constants.inputButtonConstants)
    ViewHelpers.setConstraintsForTryAgainLabel(tryAgainLabel, recordingButton, margins, "", constants.textColor)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonTapped(_:)))
    closeView.addGestureRecognizer(tap)
    
    recordingButton.addTarget(self, action: #selector(recordingButtonTapped), for: .touchUpInside)
    
//    NotificationCenter.default.addObserver(self, selector: #selector(self.resultScreenTextReceived(_:)), name: NSNotification.Name(rawValue: "resultScreenTextNotification"), object: nil)

    
    if settings.autoStart {
      titleLabel.text = constants.titleListening
      toggleRecording(recordingButton)
    }
  }
  
//  @objc func resultScreenTextReceived(_ notification: NSNotification) {
//    if let resultScreenText = notification.userInfo?["resultScreenText"] as? NSAttributedString {
//      guard let resultViewController = resultViewController else { return }
//      resultScreentimer?.invalidate()
//      resultViewController.voiceOutputText = resultScreenText
//      resultScreentimer = Timer.scheduledTimer(withTimeInterval: self.settings.showResultScreenTime, repeats: false, block: { (_) in
//        self.speechResultScreenHandler?(resultScreenText.string)
//        self.resultViewController?.dismissMe(animated: false) {
//          self.dismissMe(animated: false) {
//            self.dismissHandler?(false)
//          }
//        }
//      })
//    }
//  }
  
  // This is a fix for labels not always showing the current intrinsic multiline height
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //titleLabel.preferredMaxLayoutWidth = self.view.frame.width - VoiceUIInternalConstants.sideMarginConstant * 2
    //subtitleLabel.preferredMaxLayoutWidth = self.view.frame.width - VoiceUIInternalConstants.sideMarginConstant * 2
    self.view.layoutIfNeeded()
  }
  
  @objc func recordingButtonTapped() {
    if isRecording {
      speechController?.stopRecording()
    } else {
      toggleRecording(recordingButton)
    }
  }
  
  @objc func closeButtonTapped(_ sender: UITapGestureRecognizer) {
    self.delegate = nil
    self.speechTextHandler = nil
    self.speechErrorHandler = nil
    self.speechResultScreenHandler = nil
    speechController?.stopRecording()
    dismissMe(animated: true) {
      self.dismissHandler?(false)
    }
  }
  
  func toggleRecording(_ recordingButton: RecordingButton, dismiss: Bool = true) {
    isRecording = !isRecording
    recordingButton.animate(isRecording)
    recordingButton.setimage(isRecording)
    
    if isRecording {
      titleLabel.text = constants.titleListening
      subtitleLabel.text = constants.subtitleInitial
      subtitleBulletLabel.attributedText = ViewHelpers.add(stringList: constants.subtitleBulletList, font: subtitleBulletLabel.font, bullet: constants.subtitleBullet)
      tryAgainLabel.text = ""
    } else {
      speechController?.stopRecording()
      self.delegate?.recording(text: self.speechText, final: true, error: self.speechError)
      
      if let speechText = self.speechText {
        self.speechTextHandler?(speechText, true, self.customData)
      } else {
        self.speechErrorHandler?(self.speechError)
      }
      if dismiss {
        if settings.showResultScreen {
          speechController = nil
//          resultViewController = ResultViewController()
//          setup(resultViewController!)
        } else {
          dismissMe(animated: true) {
            self.dismissHandler?(false)
          }
        }
      }
      return
    }
    
    // TODO: Playing sound is crashing. probably because we re not stopping play, or interfering with speech controller, or setActive true/false in playSound
    //recordingButton.playSound(with: isRecording ? .startRecording : .endRecording)
    
    speechController?.startRecording(textHandler: {[weak self] (text, final, customData) in
      guard let strongSelf = self else { return }
      strongSelf.subtitleContainerView.isHidden = text.isEmpty
      strongSelf.speechText = text
      strongSelf.customData = customData
      strongSelf.speechError = nil
      strongSelf.subtitleLabel.text = text
      strongSelf.subtitleBulletLabel.text = ""
      strongSelf.titleLabel.text = text.isEmpty ? strongSelf.constants.titleListening : strongSelf.constants.titleInProgress
      
      if final {
        strongSelf.autoStopTimer.invalidate()
        strongSelf.toggleRecording(recordingButton)
        return
      } else {
        if strongSelf.isRecording {
          strongSelf.delegate?.recording(text: text, final: final, error: nil)
          strongSelf.speechTextHandler?(text, final, customData)
        }
      }

      if strongSelf.settings.autoStop && !text.isEmpty {
        strongSelf.autoStopTimer.invalidate()
        strongSelf.autoStopTimer = Timer.scheduledTimer(withTimeInterval: strongSelf.settings.autoStopTimeout, repeats: false, block: { (_) in
          strongSelf.toggleRecording(recordingButton)
        })
      }
      
      }, errorHandler: { [weak self] error in
        guard let strongSelf = self else { return }
        
        strongSelf.speechText = nil
        strongSelf.customData = nil
        strongSelf.speechError = error
        strongSelf.delegate?.recording(text: nil, final: nil, error: error)
        strongSelf.speechErrorHandler?(error)
        strongSelf.handleVoiceError(error)
    })
  }
  
//  fileprivate func setup(_ resultViewController: ResultViewController) {
//    resultViewController.dismissHandler = { [unowned self] (retry) in
//      self.resultScreentimer?.invalidate()
//      self.resultViewController?.dismissMe(animated: false) {
//        self.dismissMe(animated: false) {
//          self.dismissHandler?(true)
//        }
//      }
//    }
//    resultViewController.constants = self.settings.layout.resultScreen
//    self.present(resultViewController, animated: false)
//    resultScreentimer = Timer.scheduledTimer(withTimeInterval: self.settings.showResultScreenTimeout, repeats: false, block: { (_) in
//      self.resultViewController?.dismissMe(animated: false) {
//        self.dismissMe(animated: false) {
//          self.dismissHandler?(false)
//        }
//      }
//    })
//  }
  
  func handleVoiceError(_ error: Error?) {
    titleLabel.text = constants.titleError
    subtitleLabel.text = constants.subtitleError
    subtitleBulletLabel.attributedText = nil
    tryAgainLabel.text = constants.errorHint
    toggleRecording(recordingButton, dismiss: false)
  }
}
