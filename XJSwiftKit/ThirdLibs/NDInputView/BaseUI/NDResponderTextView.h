//
//  NDResponderTextView.h
//  ND
//
//  Created by kennethmiao on 2018/10/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDResponderTextView : UITextView
@property (nonatomic, weak) UIResponder *overrideNextResponder;
@end
