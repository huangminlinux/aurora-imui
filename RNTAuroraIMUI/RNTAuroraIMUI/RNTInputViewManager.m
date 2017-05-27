//
//  RNTInputViewManager.m
//  imuiDemo
//
//  Created by oshumini on 2017/5/27.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import "RNTInputView.h"
#import "imuiDemo-Swift.h"

@interface RNTInputViewManager : RCTViewManager <IMUIInputViewDelegate>

@property (strong, nonatomic)RNTInputView *rntInputView;
@end

@implementation RNTInputViewManager

RCT_EXPORT_VIEW_PROPERTY(onEventCallBack, RCTBubblingEventBlock)

RCT_EXPORT_MODULE()
- (UIView *)view
{
  NSBundle *bundle = [NSBundle bundleForClass: [RNTInputView class]];
  _rntInputView = [[bundle loadNibNamed:@"RNTInputView" owner:self options: nil] objectAtIndex:0];
  _rntInputView.imuiIntputView.inputViewDelegate = self;
  
  return _rntInputView;
}

RCT_CUSTOM_VIEW_PROPERTY(action, MKCoordinateRegion, RNTInputView) {

}

/// Tells the delegate that user tap send button and text input string is not empty
- (void)sendTextMessage:(NSString * _Nonnull)messageText {
  _rntInputView.onEventCallBack(@{@"eventType": @"send_text"});
}
/// Tells the delegate that IMUIInputView will switch to recording voice mode
- (void)switchToMicrophoneModeWithRecordVoiceBtn:(UIButton * _Nonnull)recordVoiceBtn {
  _rntInputView.onEventCallBack(@{@"eventType": @"send_text"});
}
/// Tells the delegate that start record voice
- (void)startRecordVoice {

}
/// Tells the delegate when finish record voice
- (void)finishRecordVoice:(NSString * _Nonnull)voicePath durationTime:(double)durationTime {
  _rntInputView.onEventCallBack(@{@"eventType": @"send_voice"});
}
/// Tells the delegate that user cancel record
- (void)cancelRecordVoice {

}
/// Tells the delegate that IMUIInputView will switch to gallery
- (void)switchToGalleryModeWithPhotoBtn:(UIButton * _Nonnull)photoBtn {

}
/// Tells the delegate that user did selected Photo in gallery
- (void)didSeletedGalleryWithAssetArr:(NSArray<PHAsset *> * _Nonnull)AssetArr {
  _rntInputView.onEventCallBack(@{@"eventType": @"send_gallery"});
}
/// Tells the delegate that IMUIInputView will switch to camera mode
- (void)switchToCameraModeWithCameraBtn:(UIButton * _Nonnull)cameraBtn {

}
/// Tells the delegate that user did shoot picture in camera mode
- (void)didShootPictureWithPicture:(NSData * _Nonnull)picture {
  _rntInputView.onEventCallBack(@{@"eventType": @"did_shoot_picture"});
}
/// Tells the delegate when starting record video
- (void)startRecordVideo {
  _rntInputView.onEventCallBack(@{@"eventType": @"start_recordVideo"});
}
/// Tells the delegate when user did shoot video in camera mode
- (void)finishRecordVideoWithVideoPath:(NSString * _Nonnull)videoPath durationTime:(double)durationTime {
  _rntInputView.onEventCallBack(@{@"eventType": @"finish_recordVideo"});
}

@end
