//
//  YSPingServices.m
//  STKitDemo
//
//  Created by SunJiangting on 15-3-9.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "YSPingServices.h"

@implementation YSPingItem

- (NSString *)description {
    switch (self.status) {
        case YSPingStatusDidStart:
            return [NSString stringWithFormat:@"PING %@ (%@): %ld data bytes",self.originalAddress, self.IPAddress, (long)self.dateBytesLength];
        case YSPingStatusDidReceivePacket:
            return [NSString stringWithFormat:@"%ld bytes from %@: icmp_seq=%ld ttl=%ld time=%.3f ms", (long)self.dateBytesLength, self.IPAddress, (long)self.ICMPSequence, (long)self.timeToLive, self.timeMilliseconds];
        case YSPingStatusDidTimeout:
            return [NSString stringWithFormat:@"Request timeout for icmp_seq %ld", (long)self.ICMPSequence];
        case YSPingStatusDidFailToSendPacket:
            return [NSString stringWithFormat:@"Fail to send packet to %@: icmp_seq=%ld", self.IPAddress, (long)self.ICMPSequence];
        case YSPingStatusDidReceiveUnexpectedPacket:
            return [NSString stringWithFormat:@"Receive unexpected packet from %@: icmp_seq=%ld", self.IPAddress, (long)self.ICMPSequence];
        case YSPingStatusError:
            return [NSString stringWithFormat:@"Can not ping to %@", self.originalAddress];
        default:
            break;
    }
    if (self.status == YSPingStatusDidReceivePacket) {
    }
    return super.description;
}

+ (NSString *)statisticsWithPingItems:(NSArray *)pingItems {
    //    --- ping statistics ---
    //    5 packets transmitted, 5 packets received, 0.0% packet loss
    //    round-trip min/avg/max/stddev = 4.445/9.496/12.210/2.832 ms
    NSString *address = [pingItems.firstObject originalAddress];
    __block NSInteger receivedCount = 0, allCount = 0;
    [pingItems enumerateObjectsUsingBlock:^(YSPingItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.status != YSPingStatusFinished && obj.status != YSPingStatusError) {
            allCount ++;
            if (obj.status == YSPingStatusDidReceivePacket) {
                receivedCount ++;
            }
        }
    }];
    
    NSMutableString *description = [NSMutableString stringWithCapacity:50];
    [description appendFormat:@"--- %@ ping statistics ---\n", address];
    
    CGFloat lossPercent = (CGFloat)(allCount - receivedCount) / MAX(1.0, allCount) * 100;
    [description appendFormat:@"%ld packets transmitted, %ld packets received, %.1f%% packet loss\n", (long)allCount, (long)receivedCount, lossPercent];
    return [description stringByReplacingOccurrencesOfString:@".0%" withString:@"%"];
}
@end

@interface YSPingServices () <YSSimplePingDelegate> {
    BOOL _hasStarted;
    BOOL _isTimeout;
    NSInteger   _repingTimes;
    NSInteger   _sequenceNumber;
    NSMutableArray *_pingItems;
}

@property(nonatomic, copy)   NSString   *address;
@property(nonatomic, strong) YSSimplePing *simplePing;

@property(nonatomic, strong)void(^callbackHandler)(YSPingItem *item, NSArray *pingItems);

@end

@implementation YSPingServices

+ (YSPingServices *)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(YSPingItem *item, NSArray *pingItems))handler {
    YSPingServices *services = [[YSPingServices alloc] initWithAddress:address];
    services.callbackHandler = handler;
    [services startPing];
    return services;
}

- (instancetype)initWithAddress:(NSString *)address {
    self = [super init];
    if (self) {
        self.timeoutMilliseconds = 500;
        self.maximumPingTimes = 100;
        self.address = address;
        self.simplePing = [[YSSimplePing alloc] initWithHostName:address];
        self.simplePing.addressStyle = YSSimplePingAddressStyleAny;
        self.simplePing.delegate = self;
        _pingItems = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)startPing {
    _repingTimes = 0;
    _hasStarted = NO;
    [_pingItems removeAllObjects];
    [self.simplePing start];
}

- (void)reping {
    [self.simplePing stop];
    [self.simplePing start];
}

- (void)_timeoutActionFired {
    YSPingItem *pingItem = [[YSPingItem alloc] init];
    pingItem.ICMPSequence = _sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = YSPingStatusDidTimeout;
    [self.simplePing stop];
    [self _handlePingItem:pingItem];
}

- (void)_handlePingItem:(YSPingItem *)pingItem {
    if (pingItem.status == YSPingStatusDidReceivePacket || pingItem.status == YSPingStatusDidTimeout) {
        [_pingItems addObject:pingItem];
    }
    if (_repingTimes < self.maximumPingTimes - 1) {
        if (self.callbackHandler) {
            self.callbackHandler(pingItem, [_pingItems copy]);
        }
        _repingTimes ++;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(reping) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    } else {
        if (self.callbackHandler) {
            self.callbackHandler(pingItem, [_pingItems copy]);
        }
        [self cancel];
    }
}

- (void)cancel {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    [self.simplePing stop];
    YSPingItem *pingItem = [[YSPingItem alloc] init];
    pingItem.status = YSPingStatusFinished;
    [_pingItems addObject:pingItem];
    if (self.callbackHandler) {
        self.callbackHandler(pingItem, [_pingItems copy]);
    }
}

- (void)st_simplePing:(YSSimplePing *)pinger didStartWithAddress:(NSData *)address {
    NSData *packet = [pinger packetWithPingData:nil];
    if (!_hasStarted) {
        YSPingItem *pingItem = [[YSPingItem alloc] init];
        pingItem.IPAddress = pinger.IPAddress;
        pingItem.originalAddress = self.address;
        pingItem.dateBytesLength = packet.length - sizeof(STICMPHeader);
        pingItem.status = YSPingStatusDidStart;
        if (self.callbackHandler) {
            self.callbackHandler(pingItem, nil);
        }
        _hasStarted = YES;
    }
    [pinger sendPacket:packet];
    [self performSelector:@selector(_timeoutActionFired) withObject:nil afterDelay:self.timeoutMilliseconds / 1000.0];
}

// If this is called, the SimplePing object has failed.  By the time this callback is
// called, the object has stopped (that is, you don't need to call -stop yourself).

// IMPORTANT: On the send side the packet does not include an IP header.
// On the receive side, it does.  In that case, use +[SimplePing icmpInPacket:]
// to find the ICMP header within the packet.

- (void)st_simplePing:(YSSimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    _sequenceNumber = sequenceNumber;
}

- (void)st_simplePing:(YSSimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    _sequenceNumber = sequenceNumber;
    YSPingItem *pingItem = [[YSPingItem alloc] init];
    pingItem.ICMPSequence = _sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = YSPingStatusDidFailToSendPacket;
    [self _handlePingItem:pingItem];
}

- (void)st_simplePing:(YSSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    YSPingItem *pingItem = [[YSPingItem alloc] init];
    pingItem.ICMPSequence = _sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = YSPingStatusDidReceiveUnexpectedPacket;
//    [self _handlePingItem:pingItem];
}

- (void)st_simplePing:(YSSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet timeToLive:(NSInteger)timeToLive sequenceNumber:(uint16_t)sequenceNumber timeElapsed:(NSTimeInterval)timeElapsed {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    YSPingItem *pingItem = [[YSPingItem alloc] init];
    pingItem.IPAddress = pinger.IPAddress;
    pingItem.dateBytesLength = packet.length;
    pingItem.timeToLive = timeToLive;
    pingItem.timeMilliseconds = timeElapsed * 1000;
    pingItem.ICMPSequence = sequenceNumber;
    pingItem.originalAddress = self.address;
    pingItem.status = YSPingStatusDidReceivePacket;
    [self _handlePingItem:pingItem];
}

- (void)st_simplePing:(YSSimplePing *)pinger didFailWithError:(NSError *)error {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_timeoutActionFired) object:nil];
    [self.simplePing stop];
    
    YSPingItem *errorPingItem = [[YSPingItem alloc] init];
    errorPingItem.originalAddress = self.address;
    errorPingItem.status = YSPingStatusError;
    if (self.callbackHandler) {
        self.callbackHandler(errorPingItem, [_pingItems copy]);
    }
    
    YSPingItem *pingItem = [[YSPingItem alloc] init];
    pingItem.originalAddress = self.address;
    pingItem.IPAddress = pinger.IPAddress ?: pinger.hostName;
    [_pingItems addObject:pingItem];
    pingItem.status = YSPingStatusFinished;
    if (self.callbackHandler) {
        self.callbackHandler(pingItem, [_pingItems copy]);
    }
}
@end
