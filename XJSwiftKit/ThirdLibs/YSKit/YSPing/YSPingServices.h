//
//  YSPingServices.h
//  STKitDemo
//
//  Created by SunJiangting on 15-3-9.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "YSSimplePing.h"

typedef NS_ENUM(NSInteger, YSPingStatus) {
    YSPingStatusDidStart,
    YSPingStatusDidFailToSendPacket,
    YSPingStatusDidReceivePacket,
    YSPingStatusDidReceiveUnexpectedPacket,
    YSPingStatusDidTimeout,
    YSPingStatusError,
    YSPingStatusFinished,
};

@interface YSPingItem : NSObject

@property(nonatomic) NSString *originalAddress;
@property(nonatomic, copy) NSString *IPAddress;

@property(nonatomic) NSUInteger dateBytesLength;
@property(nonatomic) double     timeMilliseconds;
@property(nonatomic) NSInteger  timeToLive;
@property(nonatomic) NSInteger  ICMPSequence;

@property(nonatomic) YSPingStatus status;

+ (NSString *)statisticsWithPingItems:(NSArray *)pingItems;

@end

@interface YSPingServices : NSObject

/// 超时时间, default 500ms
@property(nonatomic) double timeoutMilliseconds;

+ (YSPingServices *)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(YSPingItem *pingItem, NSArray *pingItems))handler;

@property(nonatomic) NSInteger  maximumPingTimes;
- (void)cancel;

@end
