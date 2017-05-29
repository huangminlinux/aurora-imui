//
//  IMUIMessageListViewManager.m
//  imuiDemo
//
//  Created by oshumini on 2017/5/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTViewManager.h>
#import "RNTMessageListView.h"
#import <RNTAuroraIMUI/RNTAuroraIMUI-Swift.h>

@interface RNTMessageListViewManager : RCTViewManager <IMUIMessageMessageCollectionViewDelegate>

//@property (nonatomic, copy) RCTBubblingEventBlock messageListEventCallBack;
@property (strong, nonatomic)RNTMessageListView *messageList;

/// Tells the delegate that user tap message cell
- (void)messageCollectionView:(UICollectionView * _Nonnull)_ forItemAt:(NSIndexPath * _Nonnull)forItemAt model:(id <IMUIMessageModelProtocol> _Nonnull)model;
/// Tells the delegate that user tap message bubble
- (void)messageCollectionViewWithDidTapMessageBubbleInCell:(UICollectionViewCell * _Nonnull)didTapMessageBubbleInCell model:(id <IMUIMessageModelProtocol> _Nonnull)model;
/// Tells the delegate that user tap header image in message cell
- (void)messageCollectionViewWithDidTapHeaderImageInCell:(UICollectionViewCell * _Nonnull)didTapHeaderImageInCell model:(id <IMUIMessageModelProtocol> _Nonnull)model;
/// Tells the delegate that user tap statusView in message cell
- (void)messageCollectionViewWithDidTapStatusViewInCell:(UICollectionViewCell * _Nonnull)didTapStatusViewInCell model:(id <IMUIMessageModelProtocol> _Nonnull)model;
/// Tells the delegate that the message cell will show in screen
- (void)messageCollectionView:(UICollectionView * _Nonnull)_ willDisplayMessageCell:(UICollectionViewCell * _Nonnull)willDisplayMessageCell forItemAt:(NSIndexPath * _Nonnull)forItemAt model:(id <IMUIMessageModelProtocol> _Nonnull)model;
/// Tells the delegate that message cell end displaying
- (void)messageCollectionView:(UICollectionView * _Nonnull)_ didEndDisplaying:(UICollectionViewCell * _Nonnull)didEndDisplaying forItemAt:(NSIndexPath * _Nonnull)forItemAt model:(id <IMUIMessageModelProtocol> _Nonnull)model;
/// Tells the delegate when messageCollection beginDragging
- (void)messageCollectionView:(UICollectionView * _Nonnull)willBeginDragging;

@end

@implementation RNTMessageListViewManager

RCT_EXPORT_VIEW_PROPERTY(onEventCallBack, RCTBubblingEventBlock)

RCT_EXPORT_MODULE()
- (UIView *)view
{
//  let bundle = Bundle.imuiBundle()
//  view = bundle.loadNibNamed("IMUIMessageCollectionView", owner: self, options: nil)?.first as! UIView
  NSBundle *bundle = [NSBundle bundleForClass: [RNTMessageListView class]];
  
  
  _messageList = [[bundle loadNibNamed:@"RNTMessageListView" owner:self options: nil] objectAtIndex:0];
  _messageList.messageList.delegate = self;
  
  return _messageList;
  
}

RCT_CUSTOM_VIEW_PROPERTY(action, MKCoordinateRegion, RNTMessageListView) {
//  view.action = [RCTConvert NSArray:json];
  NSArray *arr = [RCTConvert NSArray: json];
  if([arr count] == 0) { return; }
  
  NSDictionary *action = [arr firstObject];
  NSString *actionType = action[@"actionType"];
  
  
  if([actionType isEqualToString:@"send_message"] ) {
    NSArray *messages = action[@"messages"];
    NSDictionary *message = [messages firstObject];
    RNTMessageModel * messageModel = [self convertMessageDicToModel:message];
    [view.messageList appendMessageWith: messageModel];
  }
  
  if([actionType isEqualToString:@"receive_message"] ) {
    
  }
  
  if([actionType isEqualToString:@"load_history_message"] ) {
    
  }
  
  if([actionType isEqualToString:@"update_message"] ) {
    
  }
}

- (RNTMessageModel *)convertMessageDicToModel:(NSDictionary *)message {
  return [[RNTMessageModel alloc] initWithMessageDic: message];
}

// - MARK: IMUIMessageCollectionViewDelegate

- (void)sendEventWithType:(NSString *)type model:(id)model {
  if(!_messageList.onEventCallBack) { return; }
  
  NSMutableDictionary *event = @{}.mutableCopy;
  RNTMessageModel *message = model;
  NSDictionary *msgDic = message.messageDictionary;
  event[@"message"] = msgDic;
  event[@"type"] = type;
  _messageList.onEventCallBack(event);
}

- (void)sendEventWithType:(NSString *)type {
  if(!_messageList.onEventCallBack) { return; }
  
  NSMutableDictionary *event = @{}.mutableCopy;
  event[@"type"] = type;
  _messageList.onEventCallBack(event);
}

/// Tells the delegate that user tap message bubble
- (void)messageCollectionViewWithDidTapMessageBubbleInCell:(UICollectionViewCell *)didTapMessageBubbleInCell model:(id)model {

  [self sendEventWithType:@"tap_content_bubble" model: model];
}


/// Tells the delegate that user tap message cell
//self.delegate?.messageCollectionView(didTapMessageBubbleInCell: self, model: self.message!)
- (void)messageCollectionView:(UICollectionView *)_ forItemAt:(NSIndexPath * _Nonnull)forItemAt model:(id)model {
  
}

/// Tells the delegate that user tap header image in message cell
- (void)messageCollectionViewWithDidTapHeaderImageInCell:(UICollectionViewCell * _Nonnull)didTapHeaderImageInCell model:(id <IMUIMessageModelProtocol> _Nonnull)model {
  [self sendEventWithType:@"tap_header" model: model];
}
/// Tells the delegate that user tap statusView in message cell
- (void)messageCollectionViewWithDidTapStatusViewInCell:(UICollectionViewCell * _Nonnull)didTapStatusViewInCell model:(id <IMUIMessageModelProtocol> _Nonnull)model {
  [self sendEventWithType:@"tap_status_view" model: model];
}
/// Tells the delegate that the message cell will show in screen
- (void)messageCollectionView:(UICollectionView * _Nonnull)aaa willDisplayMessageCell:(UICollectionViewCell * _Nonnull)willDisplayMessageCell forItemAt:(NSIndexPath * _Nonnull)forItemAt model:(id <IMUIMessageModelProtocol> _Nonnull)model {
  
}
/// Tells the delegate that message cell end displaying
- (void)messageCollectionView:(UICollectionView * _Nonnull)_ didEndDisplaying:(UICollectionViewCell * _Nonnull)didEndDisplaying forItemAt:(NSIndexPath * _Nonnull)forItemAt model:(id <IMUIMessageModelProtocol> _Nonnull)model {
  
}
/// Tells the delegate when messageCollection beginDragging
- (void)messageCollectionView:(UICollectionView * _Nonnull)willBeginDragging {
  [self sendEventWithType:@"will_dragging_messagelist"];
}

@end
