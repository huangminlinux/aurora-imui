//
//  RNTMessageListView.h
//  imuiDemo
//
//  Created by oshumini on 2017/5/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <RNTAuroraIMUI/RNTAuroraIMUI-Swift.h>
#import <UIKit/UIKit.h>

#import <React/RCTComponent.h>


@interface RNTMessageListView : UIView
@property (weak, nonatomic) IBOutlet IMUIMessageCollectionView *messageList;
@property(assign, nonatomic)BOOL action;
//@property (nonatomic, copy) RCTBubblingEventBlock onEventCallBack;
@property (nonatomic, copy) RCTBubblingEventBlock onAvatarClick;
@property (nonatomic, copy) RCTBubblingEventBlock onMsgClick;
@property (nonatomic, copy) RCTBubblingEventBlock onStatusViewClick;

@property (nonatomic, copy) RCTBubblingEventBlock onBeginDragMessageList;

@end
