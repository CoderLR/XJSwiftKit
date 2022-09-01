//
//  NDHelper.h
//  ND
//
//  Created by kennethmiao on 2018/11/1.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TAsyncImageComplete)(NSString *path, UIImage *image);

@interface NDHelper : NSObject
+ (void)asyncDecodeImage:(NSString *)path complete:(TAsyncImageComplete)complete;
@end
