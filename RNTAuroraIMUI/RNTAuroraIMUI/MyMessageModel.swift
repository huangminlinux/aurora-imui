//
//  MyMessageModel.swift
//  IMUIChat
//
//  Created by oshumini on 2017/3/5.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit



open class RNTMessageModel: IMUIMessageModel {
  static let kMsgKeyStatus = "status"
  static let kMsgStatusSuccess = "send_succeed"
  static let kMsgStatusSending = "send_going"
  static let kMsgStatusFail = "send_failed"
  static let kMsgStatusDownloadFail = "download_failed"
  static let kMsgStatusDownloading = "downloading"
  

  
  static let kMsgKeyMsgType = "msgType"
  static let kMsgTypeText = "text"
  static let kMsgTypeVoice = "voice"
  static let kMsgTypeVideo = "video"
  static let kMsgTypeImage = "image"

  static let kMsgKeyMsgId = "msgId"
  static let kMsgKeyFromUser = "fromUser"
  static let kMsgKeyText = "text"
  static let kMsgKeyisOutgoing = "isOutgoing"
  static let kMsgKeyMediaFilePath = "mediaPath"
  static let kMsgKeyDuration = "duration"
  static let kUserKeyUerId = "userId"
  static let kUserKeyDisplayName = "diaplayName"
  static let kUserAvatarPath = "avatarPath"
  
  
  open var myTextMessage: String = ""
  
  var mediaPath: String = ""

  
  override open func mediaFilePath() -> String {
    return mediaPath
  }

  
  override open var resizableBubbleImage: UIImage {
    // return defoult message bubble
    return super.resizableBubbleImage
  }
  
  public init(msgId: String, messageStatus: IMUIMessageStatus, fromUser: RNTUser, isOutGoing: Bool, date: Date, status: IMUIMessageStatus, type: IMUIMessageType, text: String, mediaPath: String, layout: IMUIMessageCellLayoutProtocal?) {
    
    self.myTextMessage = text
    self.mediaPath = mediaPath
    
    super.init(msgId: msgId, messageStatus: messageStatus, fromUser: fromUser, isOutGoing: isOutGoing, date: date, status: status, type: type, cellLayout: layout)
  }
  
  open convenience init(messageDic: NSDictionary) {
    
    let msgId = messageDic.object(forKey: RNTMessageModel.kMsgKeyMsgId) as! String
    let msgTypeString = messageDic.object(forKey: RNTMessageModel.kMsgKeyMsgType) as? String
    let statusString = messageDic.object(forKey: RNTMessageModel.kMsgKeyStatus) as? String
    let isOutgoing = messageDic.object(forKey: RNTMessageModel.kMsgKeyisOutgoing) as? Bool
    let messageText = messageDic.object(forKey: RNTMessageModel.kMsgKeyText) as? String
    
    var mediaFilePath = messageDic.object(forKey: RNTMessageModel.kMsgKeyMediaFilePath) as? String
    if let _ = mediaFilePath {
      
    } else {
      mediaFilePath = ""
    }
    
    var text = messageDic.object(forKey: RNTMessageModel.kMsgKeyText) as? String
    if let _ = text {
      
    } else {
      text = ""
    }
    
    var msgType: IMUIMessageType?
    // TODO: duration
    let userDic = messageDic.object(forKey: RNTMessageModel.kMsgKeyFromUser) as? NSDictionary
    let user = RNTUser(userDic: userDic!)
    
    var textLayout: MyMessageCellLayout?
    
    if let typeString = msgTypeString {
      if typeString == RNTMessageModel.kMsgTypeText {
        msgType = .text
        textLayout = MyMessageCellLayout(isOutGoingMessage: isOutgoing!,
                                       isNeedShowTime: false,
                                       bubbleContentSize: RNTMessageModel.calculateTextContentSize(text: text!))
      }
      
      if typeString == RNTMessageModel.kMsgTypeImage {
        msgType = .image
      }
      
      if typeString == RNTMessageModel.kMsgTypeVoice {
        msgType = .voice
      }
      
      if typeString == RNTMessageModel.kMsgTypeVideo {
        msgType = .video
      }
    }
    
    var msgStatus = IMUIMessageStatus.success
    if let statusString = statusString {
      
      if statusString == RNTMessageModel.kMsgStatusSuccess {
        msgStatus = .success
      }
      
      if statusString == RNTMessageModel.kMsgStatusFail {
        msgStatus = .failed
      }
      
      if statusString == RNTMessageModel.kMsgStatusSending {
        msgStatus = .sending
      }
      
      if statusString == RNTMessageModel.kMsgStatusDownloadFail {
        msgStatus = .mediaDownloadFail
      }
      
      if statusString == RNTMessageModel.kMsgStatusDownloading {
        msgStatus = .mediaDownloading
      }
      
    }
    
    self.init(msgId: msgId, messageStatus: msgStatus, fromUser: user, isOutGoing: isOutgoing!, date: Date(), status: msgStatus, type: msgType!, text: text!, mediaPath: mediaFilePath!, layout:  textLayout)

  }
  
  convenience init(msgId: String, text: String, isOutGoing: Bool, user: RNTUser) {

    let myLayout = MyMessageCellLayout(isOutGoingMessage: isOutGoing,
                                       isNeedShowTime: false,
                                       bubbleContentSize: RNTMessageModel.calculateTextContentSize(text: text))
    let msgId = "\(NSDate().timeIntervalSince1970 * 1000)"
    self.init(msgId: msgId, messageStatus: .failed, fromUser: user, isOutGoing: isOutGoing, date: Date(), status: .success, type: .text, text: text, mediaPath: "", layout:  myLayout)
  }

  convenience init(msgId: String, voicePath: String, isOutGoing: Bool, user: RNTUser) {
    self.init(msgId: msgId, messageStatus: .sending, fromUser: user, isOutGoing: isOutGoing, date: Date(), status: .success, type: .voice, text: "", mediaPath: voicePath, layout:  nil)
  }
  
  convenience init(msgId: String, imagePath: String, isOutGoing: Bool, user: RNTUser) {
    self.init(msgId: msgId, messageStatus: .sending, fromUser: user, isOutGoing: isOutGoing, date: Date(), status: .success, type: .image, text: "", mediaPath: imagePath, layout:  nil)
  }
  
  convenience init(msgId: String, videoPath: String, isOutGoing: Bool, user: RNTUser) {
    self.init(msgId: msgId, messageStatus: .sending, fromUser: user, isOutGoing: isOutGoing, date: Date(), status: .success, type: .video, text: "", mediaPath: videoPath, layout:  nil)
  }
  
  override open func text() -> String {
    return self.myTextMessage
  }
  
  static func calculateTextContentSize(text: String) -> CGSize {
    let textSize  = text.sizeWithConstrainedWidth(with: IMUIMessageCellLayout.bubbleMaxWidth, font: UIFont.systemFont(ofSize: 18))
    
    return textSize
  }
  
  public var messageDictionary: NSDictionary {
    get {
      
      var messageDic = NSMutableDictionary()
      messageDic.setValue(self.msgId, forKey: RNTMessageModel.kMsgKeyMsgId)
      messageDic.setValue(self.isOutGoing, forKey: RNTMessageModel.kMsgKeyisOutgoing)

      
      switch self.type {
      case .text:
        messageDic.setValue(RNTMessageModel.kMsgTypeText, forKey: RNTMessageModel.kMsgKeyMsgType)
        messageDic.setValue(self.text(), forKey: RNTMessageModel.kMsgKeyText)
        break
      case .image:
        messageDic.setValue(RNTMessageModel.kMsgTypeImage, forKey: RNTMessageModel.kMsgKeyMsgType)
        messageDic.setValue(self.mediaPath, forKey: RNTMessageModel.kMsgKeyMediaFilePath)
        break
      case .voice:
        messageDic.setValue(RNTMessageModel.kMsgTypeVoice, forKey: RNTMessageModel.kMsgKeyMsgType)
        messageDic.setValue(self.mediaPath, forKey: RNTMessageModel.kMsgKeyMediaFilePath)
        messageDic.setValue(self.duration, forKey: RNTMessageModel.kMsgKeyDuration)
        break
      case .video:
        messageDic.setValue(RNTMessageModel.kMsgTypeVideo, forKey: RNTMessageModel.kMsgKeyMsgType)
        messageDic.setValue(self.mediaPath, forKey: RNTMessageModel.kMsgKeyMediaFilePath)
        messageDic.setValue(self.duration, forKey: RNTMessageModel.kMsgKeyDuration)
        break
      case .custom:
        break
        
      default:
        break
      }
      
      var msgStatus = ""
      switch self.status {
      case .success:
        msgStatus = RNTMessageModel.kMsgStatusSuccess
        break
      case .sending:
        msgStatus = RNTMessageModel.kMsgStatusSending
        break
      case .failed:
        msgStatus = RNTMessageModel.kMsgStatusFail
        break
      case .mediaDownloading:
        msgStatus = RNTMessageModel.kMsgStatusDownloading
        break
      case .mediaDownloadFail:
        msgStatus = RNTMessageModel.kMsgStatusDownloadFail
        break
      }
      
      messageDic.setValue(msgStatus, forKey: "status")
      let userDic = NSMutableDictionary()
      userDic.setValue(self.fromUser.userId(), forKey: "userId")
      userDic.setValue(self.fromUser.displayName(), forKey: "diaplayName")
      let user = self.fromUser as! RNTUser
      userDic.setValue(user.rAvatarFilePath, forKey: "avatarPath")
      
      messageDic.setValue(userDic, forKey: "fromUser")
      messageDic.setValue(self.msgId, forKey: "msgId")
      return messageDic
    }
  }
}


//MARK - IMUIMessageCellLayoutProtocal
class MyMessageCellLayout: IMUIMessageCellLayout {
  
  override init(isOutGoingMessage: Bool, isNeedShowTime: Bool, bubbleContentSize: CGSize) {
    
    super.init(isOutGoingMessage: isOutGoingMessage, isNeedShowTime: isNeedShowTime, bubbleContentSize: bubbleContentSize)
  }
  
  override var bubbleContentInset: UIEdgeInsets {
    
    if isOutGoingMessage {
      return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15)
    } else {
      return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
    }
  }
  
}


