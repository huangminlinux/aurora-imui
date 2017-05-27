//
//  RNTInputView.h
//  imuiDemo
//
//  Created by oshumini on 2017/5/27.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imuiDemo-Swift.h"

#import <React/RCTComponent.h>

@interface RNTInputView : UIView
@property (weak, nonatomic) IBOutlet IMUIInputView *imuiIntputView;
@property(assign, nonatomic)BOOL action;
@property (nonatomic, copy) RCTBubblingEventBlock onEventCallBack;

@end
